set serveroutput on;
---------------------------
declare
  l_blob blob;
begin
  select blob_value into l_blob from file_raw_data where frd_id=5;
  file_adapter_data_imp_2.insert_file_text_data(
    i_frd_id      => 5,--in file_raw_data.frd_id%type,
    i_blob        => l_blob,--in file_raw_data.blob_value%type,
    i_fmd_id      => 5,--in file_meta_data.fmd_id%type,
    i_charset_id  => 871,--in file_meta_data.ora_charset_id%type,
    i_ftd_id      => 1704);--file_text_data.ftd_id%type);
end;
/
---------------------------
select * from file_text_data where ftd_id=1704;
delete file_text_data where ftd_id=1704;
commit;
---------------------------
select * from table(xlsx_parser.get_worksheets( (select blob_value from file_raw_data where frd_id=5) ));


-- YEAH!!!
select * from table(xlsx_parser.parse( 
        p_xlsx_name      => 'financial_short_sample.xlsx',
        p_xlsx_content => (select blob_value from file_raw_data where frd_id=5)
) 
        );
                
select * from table(xlsx_parser.get_worksheets( (select blob_value from file_raw_data where frd_id=5) ) )
where column_value not like '%xml%'
;
-- entspricht
select regexp_substr('xl/worksheets/sheet1.xml', '(([A-Za-z0-9])*.xml)') from dual;


select *from file_meta_data;

select * from file_meta_data;

set serveroutput on;

begin
  dbms_output.put_line('?'||utl_i18n.map_charset('iso-8859-p1', utl_i18n.GENERIC_CONTEXT, utl_i18n.IANA_TO_ORACLE ) );
  dbms_output.put_line('#'||utl_i18n.map_charset('utf8', utl_i18n.GENERIC_CONTEXT, utl_i18n.IANA_TO_ORACLE));
end;
/

--------------------------------------------------------------------------------

create or replace package xlsx_parser authid definer is

-- we currently support 50 columns - but this can easily be increased. Just increase the columns in the
-- record definition and add corresponing lines into the package body
type xlsx_row_t is record( 
  line# number,
  col01 varchar2(4000), col02 varchar2(4000), col03 varchar2(4000), col04 varchar2(4000), col05 varchar2(4000),
  col06 varchar2(4000), col07 varchar2(4000), col08 varchar2(4000), col09 varchar2(4000), col10 varchar2(4000),
  col11 varchar2(4000), col12 varchar2(4000), col13 varchar2(4000), col14 varchar2(4000), col15 varchar2(4000),
  col16 varchar2(4000), col17 varchar2(4000), col18 varchar2(4000), col19 varchar2(4000), col20 varchar2(4000),
  col21 varchar2(4000), col22 varchar2(4000), col23 varchar2(4000), col24 varchar2(4000), col25 varchar2(4000),
  col26 varchar2(4000), col27 varchar2(4000), col28 varchar2(4000), col29 varchar2(4000), col30 varchar2(4000),
  col31 varchar2(4000), col32 varchar2(4000), col33 varchar2(4000), col34 varchar2(4000), col35 varchar2(4000),
  col36 varchar2(4000), col37 varchar2(4000), col38 varchar2(4000), col39 varchar2(4000), col40 varchar2(4000),
  col41 varchar2(4000), col42 varchar2(4000), col43 varchar2(4000), col44 varchar2(4000), col45 varchar2(4000),
  col46 varchar2(4000), col47 varchar2(4000), col48 varchar2(4000), col49 varchar2(4000), col50 varchar2(4000));
type xlsx_tab_t is table of xlsx_row_t;

    -- MUST
    function xlsx_parse( 
        p_xlsx_content   in blob, 
        p_worksheet_name in varchar2 default 'sheet1') 
      return xlsx_tab_t pipelined; 

    --==================================================================================================================
    -- table function to list the available worksheets in an XLSX file
    --
    -- p_xlsx_name    - NAME column of the APEX_APPLICATION_TEMP_FILES table
    -- p_xlsx_content - XLSX as a BLOB
    -- 
    -- usage:
    --
    -- select * from table( 
    --    xlsx_parser.get_worksheets( 
    --        p_xlsx_name      => :P1_XLSX_FILE ) );
    --
    function get_worksheets(
        p_xlsx_content   in blob     default null, 
        p_xlsx_name      in varchar2 default null ) return 
        sys.ora_mining_varchar2_nt
--        apex_t_varchar2 
        pipelined;

    --==================================================================================================================
    -- date and datetimes are stored as a number in XLSX; this function converts that number to an ORACLE DATE
    --
    -- p_xlsx_date_number   numeric XLSX date value
    -- 
    -- usage:
    -- select xlsx_parser.get_date( 46172 ) from dual;
    --
    function get_date( p_xlsx_date_number in number ) return date;

end xlsx_parser;
/

create or replace package body xlsx_parser is
    g_worksheets_path_prefix constant varchar2(14) := 'xl/worksheets/';

    --==================================================================================================================
    function get_date( p_xlsx_date_number in number ) return date is
    begin
        return 
            case when p_xlsx_date_number > 61 
                      then DATE'1900-01-01' - 2 + p_xlsx_date_number
                      else DATE'1900-01-01' - 1 + p_xlsx_date_number
            end;
    end get_date;

    --==================================================================================================================
    procedure get_blob_content( 
        p_xlsx_name    in            varchar2,
        p_xlsx_content in out nocopy blob ) 
    is
    begin
        if p_xlsx_name is not null then
            select blob_content into p_xlsx_content
              from apex_application_temp_files
             where name = p_xlsx_name;
        end if;
    exception 
        when no_data_found then
            null;
    end get_blob_content;

    --==================================================================================================================
    function extract_worksheet(
        p_xlsx           in blob, 
        p_worksheet_name in varchar2 ) return blob 
    is
        l_worksheet blob;
    begin
        if p_xlsx is null or p_worksheet_name is null then
           return null; 
        end if;

        l_worksheet := file_adapter_data_imp2.get_file(
--        l_worksheet := apex_zip.get_file_content(
            p_zipped_blob => p_xlsx,
            p_file_name   => g_worksheets_path_prefix || p_worksheet_name || '.xml' );

        if l_worksheet is null then
            raise_application_error(-20000, 'WORKSHEET "' || p_worksheet_name || '" DOES NOT EXIST');
        end if;
        return l_worksheet;
    end extract_worksheet;

    --==================================================================================================================
    procedure extract_shared_strings(
        p_xlsx           in blob,
        p_strings        in out nocopy wwv_flow_global.vc_arr2 )
    is
        l_shared_strings blob;
    begin

l_shared_strings := file_adapter_data_imp2.get_file(
--l_shared_strings := apex_zip.get_file_content(
            p_zipped_blob => p_xlsx,
            p_file_name   => 'xl/sharedStrings.xml' );

        if l_shared_strings is null then
            return;
        end if;

        select shared_string
          bulk collect into p_strings
          from xmltable(
              xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
              '//si'
              passing xmltype.createxml( l_shared_strings, nls_charset_id('AL32UTF8'), null )
              columns
                 shared_string varchar2(4000)   path 't/text()' );
       
    end extract_shared_strings;

    --==================================================================================================================
    procedure extract_date_styles(
        p_xlsx           in blob,
        p_format_codes   in out nocopy wwv_flow_global.vc_arr2 )
    is
        l_stylesheet blob;
    begin
    
        l_stylesheet := file_adapter_data_imp2.get_file(
--        l_stylesheet := apex_zip.get_file_content(
            p_zipped_blob => p_xlsx,
            p_file_name   => 'xl/styles.xml' );

        if l_stylesheet is null then
            return;
        end if;

        select lower( n.formatCode )
        bulk collect into p_format_codes
        from 
            xmltable(
                xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
                '//cellXfs/xf'
                passing xmltype.createxml( l_stylesheet, nls_charset_id('AL32UTF8'), null )
                columns
                   numFmtId number path '@numFmtId' ) s,
            xmltable(
                xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
                '//numFmts/numFmt'
                passing xmltype.createxml( l_stylesheet, nls_charset_id('AL32UTF8'), null )
                columns
                   formatCode varchar2(255) path '@formatCode',
                   numFmtId   number        path '@numFmtId' ) n
        where s.numFmtId = n.numFmtId ( + );

    end extract_date_styles;

    --==================================================================================================================
    function convert_ref_to_col#( p_col_ref in varchar2 ) return pls_integer is
        l_colpart  varchar2(10);
        l_linepart varchar2(10);
    begin
        l_colpart := replace(translate(p_col_ref,'1234567890','__________'), '_');
        if length( l_colpart ) = 1 then
            return ascii( l_colpart ) - 64;
        else
            return ( ascii( substr( l_colpart, 1, 1 ) ) - 64 ) * 26 + ( ascii( substr( l_colpart, 2, 1 ) ) - 64 );
        end if;
    end convert_ref_to_col#;

    --==================================================================================================================
    procedure reset_row( p_parsed_row in out nocopy xlsx_row_t ) is
    begin
        -- reset row 
        p_parsed_row.col01 := null; p_parsed_row.col02 := null; p_parsed_row.col03 := null; p_parsed_row.col04 := null; p_parsed_row.col05 := null; 
        p_parsed_row.col06 := null; p_parsed_row.col07 := null; p_parsed_row.col08 := null; p_parsed_row.col09 := null; p_parsed_row.col10 := null; 
        p_parsed_row.col11 := null; p_parsed_row.col12 := null; p_parsed_row.col13 := null; p_parsed_row.col14 := null; p_parsed_row.col15 := null; 
        p_parsed_row.col16 := null; p_parsed_row.col17 := null; p_parsed_row.col18 := null; p_parsed_row.col19 := null; p_parsed_row.col20 := null; 
        p_parsed_row.col21 := null; p_parsed_row.col22 := null; p_parsed_row.col23 := null; p_parsed_row.col24 := null; p_parsed_row.col25 := null; 
        p_parsed_row.col26 := null; p_parsed_row.col27 := null; p_parsed_row.col28 := null; p_parsed_row.col29 := null; p_parsed_row.col30 := null; 
        p_parsed_row.col31 := null; p_parsed_row.col32 := null; p_parsed_row.col33 := null; p_parsed_row.col34 := null; p_parsed_row.col35 := null; 
        p_parsed_row.col36 := null; p_parsed_row.col37 := null; p_parsed_row.col38 := null; p_parsed_row.col39 := null; p_parsed_row.col40 := null; 
        p_parsed_row.col41 := null; p_parsed_row.col42 := null; p_parsed_row.col43 := null; p_parsed_row.col44 := null; p_parsed_row.col45 := null; 
        p_parsed_row.col46 := null; p_parsed_row.col47 := null; p_parsed_row.col48 := null; p_parsed_row.col49 := null; p_parsed_row.col50 := null; 
    end reset_row;

    --==================================================================================================================

--------------------------------------------------------------------------------
  function xlsx_parse(
      p_xlsx_content   in blob, 
      p_worksheet_name in varchar2 default 'sheet1') 
    return xlsx_tab_t pipelined 
  is
    c_date_format   constant varchar2(255) := 'YYYY-MM-DD';
    l_xlsx_content  blob not null:=p_xlsx_content;
    l_worksheet     blob;

        l_shared_strings      wwv_flow_global.vc_arr2;
        l_format_codes        wwv_flow_global.vc_arr2;

        l_parsed_row          xlsx_row_t;
        l_first_row           boolean     := true;
        l_value               varchar2(32767);

        l_line#               pls_integer := 1;
        l_real_col#           pls_integer;
        l_row_has_content     boolean := false;
    begin
        l_worksheet := extract_worksheet( 
            p_xlsx           => l_xlsx_content,
            p_worksheet_name => p_worksheet_name );

        extract_shared_strings( 
            p_xlsx    => l_xlsx_content,
            p_strings => l_shared_strings );

        extract_date_styles( 
            p_xlsx    => l_xlsx_content,
            p_format_codes => l_format_codes );

        -- the actual XML parsing starts here
        for i in (
            select 
                r.xlsx_row,
                c.xlsx_col#,
                c.xlsx_col,
                c.xlsx_col_type,
                c.xlsx_col_style,
                c.xlsx_val
            from xmltable(
                xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
                '//row'
                passing xmltype.createxml( l_worksheet, nls_charset_id('AL32UTF8'), null )
                columns
                     xlsx_row number   path '@r',
                     xlsx_cols xmltype path '.'
            ) r, xmltable (
                xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
                '//c'
                passing r.xlsx_cols
                columns
                     xlsx_col#      for ordinality,
                     xlsx_col       varchar2(15)   path '@r',
                     xlsx_col_type  varchar2(15)   path '@t',
                     xlsx_col_style varchar2(15)   path '@s',
                     xlsx_val       varchar2(4000) path 'v/text()'
            ) c
            --where p_max_rows is null or r.xlsx_row <= p_max_rows
        ) loop
            if i.xlsx_col# = 1 then
                l_parsed_row.line# := l_line#;
                if not l_first_row then
                    pipe row( l_parsed_row );
                    l_line# := l_line# + 1;
                    reset_row( l_parsed_row );
                    l_row_has_content := false;
                else
                    l_first_row := false;
                end if;
            end if;

            if i.xlsx_col_type = 's' then
                if l_shared_strings.exists( i.xlsx_val + 1) then
                    l_value := l_shared_strings( i.xlsx_val + 1);
                else
                    l_value := '[Data Error: N/A]' ;
                end if;
            else 
                if l_format_codes.exists( i.xlsx_col_style + 1 ) and (
                    instr( l_format_codes( i.xlsx_col_style + 1 ), 'd' ) > 0 and
                    instr( l_format_codes( i.xlsx_col_style + 1 ), 'm' ) > 0 )
                then
                    l_value := to_char( get_date( i.xlsx_val ), c_date_format );
                else
                    l_value := i.xlsx_val;
                end if;
            end if;
 
            pragma inline( convert_ref_to_col#, 'YES' );
            l_real_col# := convert_ref_to_col#( i.xlsx_col );

            if l_real_col# between 1 and 50 then
                l_row_has_content := true;
            end if;

            -- we currently support 50 columns - but this can easily be increased. Just add additional lines
            -- as follows:
            -- when l_real_col# = {nn} then l_parsed_row.col{nn} := l_value;
            case
                when l_real_col# =  1 then l_parsed_row.col01 := l_value;
                when l_real_col# =  2 then l_parsed_row.col02 := l_value;
                when l_real_col# =  3 then l_parsed_row.col03 := l_value;
                when l_real_col# =  4 then l_parsed_row.col04 := l_value;
                when l_real_col# =  5 then l_parsed_row.col05 := l_value;
                when l_real_col# =  6 then l_parsed_row.col06 := l_value;
                when l_real_col# =  7 then l_parsed_row.col07 := l_value;
                when l_real_col# =  8 then l_parsed_row.col08 := l_value;
                when l_real_col# =  9 then l_parsed_row.col09 := l_value;
                when l_real_col# = 10 then l_parsed_row.col10 := l_value;
                when l_real_col# = 11 then l_parsed_row.col11 := l_value;
                when l_real_col# = 12 then l_parsed_row.col12 := l_value;
                when l_real_col# = 13 then l_parsed_row.col13 := l_value;
                when l_real_col# = 14 then l_parsed_row.col14 := l_value;
                when l_real_col# = 15 then l_parsed_row.col15 := l_value;
                when l_real_col# = 16 then l_parsed_row.col16 := l_value;
                when l_real_col# = 17 then l_parsed_row.col17 := l_value;
                when l_real_col# = 18 then l_parsed_row.col18 := l_value;
                when l_real_col# = 19 then l_parsed_row.col19 := l_value;
                when l_real_col# = 20 then l_parsed_row.col20 := l_value;
                when l_real_col# = 21 then l_parsed_row.col21 := l_value;
                when l_real_col# = 22 then l_parsed_row.col22 := l_value;
                when l_real_col# = 23 then l_parsed_row.col23 := l_value;
                when l_real_col# = 24 then l_parsed_row.col24 := l_value;
                when l_real_col# = 25 then l_parsed_row.col25 := l_value;
                when l_real_col# = 26 then l_parsed_row.col26 := l_value;
                when l_real_col# = 27 then l_parsed_row.col27 := l_value;
                when l_real_col# = 28 then l_parsed_row.col28 := l_value;
                when l_real_col# = 29 then l_parsed_row.col29 := l_value;
                when l_real_col# = 30 then l_parsed_row.col30 := l_value;
                when l_real_col# = 31 then l_parsed_row.col31 := l_value;
                when l_real_col# = 32 then l_parsed_row.col32 := l_value;
                when l_real_col# = 33 then l_parsed_row.col33 := l_value;
                when l_real_col# = 34 then l_parsed_row.col34 := l_value;
                when l_real_col# = 35 then l_parsed_row.col35 := l_value;
                when l_real_col# = 36 then l_parsed_row.col36 := l_value;
                when l_real_col# = 37 then l_parsed_row.col37 := l_value;
                when l_real_col# = 38 then l_parsed_row.col38 := l_value;
                when l_real_col# = 39 then l_parsed_row.col39 := l_value;
                when l_real_col# = 40 then l_parsed_row.col40 := l_value;
                when l_real_col# = 41 then l_parsed_row.col41 := l_value;
                when l_real_col# = 42 then l_parsed_row.col42 := l_value;
                when l_real_col# = 43 then l_parsed_row.col43 := l_value;
                when l_real_col# = 44 then l_parsed_row.col44 := l_value;
                when l_real_col# = 45 then l_parsed_row.col45 := l_value;
                when l_real_col# = 46 then l_parsed_row.col46 := l_value;
                when l_real_col# = 47 then l_parsed_row.col47 := l_value;
                when l_real_col# = 48 then l_parsed_row.col48 := l_value;
                when l_real_col# = 49 then l_parsed_row.col49 := l_value;
                when l_real_col# = 50 then l_parsed_row.col50 := l_value;
                else null;
            end case;

        end loop;
        if l_row_has_content then
            l_parsed_row.line# := l_line#;
            pipe row( l_parsed_row );
        end if;

        return;
    end xlsx_parse;

    --==================================================================================================================
    function get_worksheets(
        p_xlsx_content   in blob     default null, 
        p_xlsx_name      in varchar2 default null ) return sys.ora_mining_varchar2_nt pipelined 
    is
        l_zip_files           sys.ora_mining_varchar2_nt;--file_adapter_data_imp2.t_files;
        l_xlsx_content        blob;
    begin
        if p_xlsx_content is null then
            get_blob_content( p_xlsx_name, l_xlsx_content );
        else
            l_xlsx_content := p_xlsx_content;
        end if;

        l_zip_files := file_adapter_data_imp2.get_file_list(
--        l_zip_files := apex_zip.get_files(
            p_zipped_blob => l_xlsx_content );

        for i in 1 .. l_zip_files.count loop
            if substr( l_zip_files( i ), 1, length( g_worksheets_path_prefix ) ) = g_worksheets_path_prefix then
                pipe row( rtrim( substr( l_zip_files ( i ), length( g_worksheets_path_prefix ) + 1 ), '.xml' ) );
            end if;
        end loop;

        return;
    end get_worksheets;

end xlsx_parser;
/