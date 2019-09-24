create or replace package body imp_2_file_adapter_data
as
--------------------------------------------------------------------------------
-- AS_ZIP subprograms ----------------------------------------------------------
--------------------------------------------------------------------------------
  c_end_of_central_directory constant raw(4) := hextoraw( '504B0506' );         
--------------------------------------------------------------------------------
  function blob_to_num(p_blob in blob, p_len in integer, p_pos in integer) 
    return number deterministic
  is
    c_num constant number:=4294967296;
    l_out number;
  begin
    l_out := sys.utl_raw.cast_to_binary_integer( 
              sys.dbms_lob.substr( p_blob, p_len, p_pos ),
              sys.utl_raw.little_endian 
             );
    if l_out < 0 then 
      l_out := l_out + c_num;
    end if;
    return l_out;
  end blob_to_num;
--------------------------------------------------------------------------------
  function zipped_blob_to_files (
      i_zipped_blob       in blob,
      i_ora_charset_name  in varchar2,
      i_filter_sheet_name in boolean)
    return sys.ora_mining_varchar2_nt deterministic
  is
    l_zipped_blob       blob not null:=i_zipped_blob;
    l_ora_charset_name  varchar2(16 char) not null:=i_ora_charset_name;
    l_filter_sheet_name boolean:=i_filter_sheet_name;
    l_file_list         sys.ora_mining_varchar2_nt:=sys.ora_mining_varchar2_nt();
    l_filename          varchar2(255 char);
    t_ind integer;
    t_hd_ind integer;
  begin
    t_ind := nvl( sys.dbms_lob.getlength( l_zipped_blob ), 0 ) - 21;
    loop
      exit when t_ind < 1 or sys.dbms_lob.substr( l_zipped_blob, 4, t_ind ) = c_end_of_central_directory;
      t_ind := t_ind - 1;
    end loop;
--
    if t_ind > 0 then
      t_hd_ind:=blob_to_num( l_zipped_blob, 4, t_ind + 16 ) + 1;
      <<file_list_loop>>
      for i in 1 .. blob_to_num( l_zipped_blob, 2, t_ind + 8 )
      loop
        l_filename:=sys.utl_i18n.raw_to_char(
                      data => sys.dbms_lob.substr(
                        l_zipped_blob,
                        blob_to_num( l_zipped_blob, 2, t_hd_ind + 28 ),
                        t_hd_ind + 46),
                      src_charset => l_ora_charset_name);
dbms_output.put_line('filename '||l_filename);
        if (not l_filter_sheet_name or (
            l_filename like 'xl/worksheets/%' and 
            l_filename not like '%\_rels%' escape '\' )
           )
        then      
          l_file_list.extend();
          l_file_list(l_file_list.count):=l_filename;
        end if;
        t_hd_ind:=t_hd_ind + 46 + blob_to_num(l_zipped_blob, 2, t_hd_ind + 28)  -- File name length
                                + blob_to_num(l_zipped_blob, 2, t_hd_ind + 30)  -- Extra field length
                                + blob_to_num(l_zipped_blob, 2, t_hd_ind + 32); -- File comment length
      end loop file_list_loop;
    end if;    
    return l_file_list;
  end zipped_blob_to_files;
--------------------------------------------------------------------------------
  function file_blob_from_zipped_blob (
      i_zipped_blob       in blob,
      i_ora_charset_name  in varchar2,
      i_filename          in varchar2)
    return blob deterministic
  is
    l_zipped_blob blob not null:=i_zipped_blob;
    l_ora_charset_name  varchar2(16 char) not null:=i_ora_charset_name;
    l_filename varchar2(255 char) not null:=i_filename;
    t_tmp blob;
    t_ind integer;
    t_hd_ind integer;
    t_fl_ind integer;
    t_len integer;
    function little_endian( p_big number, p_bytes pls_integer := 4 )
      return raw
    is
      t_big number := p_big;
    begin
      if t_big > 2147483647 then
        t_big := t_big - 4294967296;
      end if;
      return utl_raw.substr( 
              utl_raw.cast_from_binary_integer( t_big, utl_raw.little_endian ),
              1,
              p_bytes 
             );
    end little_endian;
  begin
    t_ind := nvl( sys.dbms_lob.getlength( l_zipped_blob ), 0 ) - 21;
    loop
      exit when t_ind < 1 or sys.dbms_lob.substr( l_zipped_blob, 4, t_ind ) = c_end_of_central_directory;
      t_ind := t_ind - 1;
    end loop;
--
    if t_ind > 0 then
      t_hd_ind:=blob_to_num( l_zipped_blob, 4, t_ind + 16 ) + 1;
      <<file_list_loop>>
      for i in 1 .. blob_to_num( l_zipped_blob, 2, t_ind + 8 )
      loop
        if l_filename=sys.utl_i18n.raw_to_char(
                        data => sys.dbms_lob.substr(
                          l_zipped_blob,
                          blob_to_num( l_zipped_blob, 2, t_hd_ind + 28 ),
                          t_hd_ind + 46),
                        src_charset => l_ora_charset_name)
        then
          t_len := blob_to_num( l_zipped_blob, 4, t_hd_ind + 24 ); -- uncompressed length
          
          case 
            when t_len = 0 and substr( l_filename, -1 ) in ( '/', '\' )
              then -- directory/folder
                t_tmp:= null;
            when t_len = 0 
              then -- empty file
                t_tmp:=empty_blob();
            when dbms_lob.substr( l_zipped_blob, 2, t_hd_ind + 10 ) in ( hextoraw( '0800' )   -- deflate
                                                                       , hextoraw( '0900' ) ) -- deflate64
              then -- with compression
                t_fl_ind := blob_to_num( l_zipped_blob, 4, t_hd_ind + 42 );
                t_tmp := hextoraw( '1F8B0800000000000003' ); -- gzip header
                dbms_lob.copy( t_tmp
                             , l_zipped_blob
                             ,  blob_to_num( l_zipped_blob, 4, t_hd_ind + 20 )
                             , 11
                             , t_fl_ind + 31
                             + blob_to_num( l_zipped_blob, 2, t_fl_ind + 27 )   -- File name length
                             + blob_to_num( l_zipped_blob, 2, t_fl_ind + 29 )   -- Extra field length
                             );
                dbms_lob.append( t_tmp, utl_raw.concat( dbms_lob.substr( l_zipped_blob, 4, t_hd_ind + 16 ) -- CRC32
                                                      , little_endian( blob_to_num( l_zipped_blob, 4, t_hd_ind + 24 ) ) -- uncompressed length
                                                      )
                               );
                t_tmp:=utl_compress.lz_uncompress( t_tmp );
            when dbms_lob.substr( l_zipped_blob, 2, t_hd_ind + 10 ) = hextoraw( '0000' )
              then -- without compression
                t_fl_ind := blob_to_num( l_zipped_blob, 4, t_hd_ind + 42 );
                dbms_lob.createtemporary( t_tmp, true );
                dbms_lob.copy( t_tmp
                             , l_zipped_blob
                             , blob_to_num( l_zipped_blob, 4, t_hd_ind + 24 )
                             , 1
                             , t_fl_ind + 31
                             + blob_to_num( l_zipped_blob, 2, t_fl_ind + 27 )   -- File name length
                             + blob_to_num( l_zipped_blob, 2, t_fl_ind + 29 )   -- Extra field length
                             );
          end case;
          exit;
        end if;
        -- skip to next index header (loop)
        t_hd_ind:=t_hd_ind + 46 + blob_to_num(l_zipped_blob, 2, t_hd_ind + 28)  -- File name length
                                + blob_to_num(l_zipped_blob, 2, t_hd_ind + 30)  -- Extra field length
                                + blob_to_num(l_zipped_blob, 2, t_hd_ind + 32); -- File comment length
      end loop file_list_loop;
    end if; 
    
    return t_tmp;
  end;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------



  
-------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------


-------------------------------------------------------------------------------- 
--------------------------------------------------------------------------------
  procedure insert_file_text_data(
    i_frd_id            in file_raw_data.frd_id%type,
    i_fmd_id            in file_meta_data.fmd_id%type,
    i_ftd_id            in file_text_data.ftd_id%type,
    i_blob_value        in file_raw_data.blob_value%type,
    i_ora_charset_id    in file_meta_data.ora_charset_id%type,
    i_ora_charset_name  in file_meta_data.ora_charset_name%type)
  is
    c_xml_charset_id constant varchar2(30 char):=nls_charset_id('AL32UTF8');  -- i_ora_charset_name ???
--    c_sheet_re constant varchar2(19 char):='([A-Za-z0-9]*).xml';
    l_ridx simple_integer:=0;
    l_ftd_row file_text_data%rowtype;
    l_sheets sys.ora_mining_varchar2_nt;
    l_sheet_blob blob;
    l_shared_strings sys.ora_mining_varchar2_nt;
    l_format_codes sys.ora_mining_varchar2_nt;
    l_workbook_names sys.ora_mining_varchar2_nt;
  
  procedure query_excel_shared_strings(
    i_excel_shared_strings in out nocopy sys.ora_mining_varchar2_nt)
  is
    c_xml_file_name constant varchar2(30 char):='xl/sharedStrings.xml';
    l_xml_file_blob blob;
  begin
    l_xml_file_blob := file_blob_from_zipped_blob(
                        i_zipped_blob => i_blob_value,
                        i_ora_charset_name => i_ora_charset_name,
                        i_filename => c_xml_file_name
                       );
    if l_xml_file_blob is not null then
      select shared_string
        bulk collect into i_excel_shared_strings
        from xmltable(
              xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
              '//si'
              passing xmltype.createxml( l_xml_file_blob, c_xml_charset_id, null )
              columns
                shared_string varchar2(4000) path 't/text()' );
    end if;
  end query_excel_shared_strings;
  
  procedure query_excel_format_codes(
    i_excel_format_codes in out nocopy sys.ora_mining_varchar2_nt)
  is
    c_xml_file_name constant varchar2(30 char):='xl/styles.xml';
    l_xml_file_blob blob;
  begin
    l_xml_file_blob := file_blob_from_zipped_blob(
                        i_zipped_blob => i_blob_value,
                        i_ora_charset_name => i_ora_charset_name,
                        i_filename => c_xml_file_name
                       );
    if l_xml_file_blob is not null then
      select lower( n.formatCode )
        bulk collect into i_excel_format_codes
        from xmltable(
              xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
              '//cellXfs/xf'
              passing xmltype.createxml( l_xml_file_blob, c_xml_charset_id, null )
              columns
                seq_no for ordinality, -- order is important in case of outer join !!!
                numFmtId number path '@numFmtId' ) s,
             xmltable(
              xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
              '//numFmts/numFmt'
              passing xmltype.createxml( l_xml_file_blob, c_xml_charset_id, null )
              columns
                formatCode varchar2(255) path '@formatCode',
                numFmtId   number        path '@numFmtId' ) n
        where s.numFmtId = n.numFmtId ( + )
        order by seq_no; -- order is important in case of outer join !!!
    end if;
  end query_excel_format_codes;
  
  procedure query_excel_workbook_names(
    i_excel_workbook_names in out nocopy sys.ora_mining_varchar2_nt)
  is
    c_xml_file_name constant varchar2(30 char):='xl/workbook.xml';
    l_xml_file_blob blob;
  begin
    l_xml_file_blob := file_blob_from_zipped_blob(
                        i_zipped_blob => i_blob_value,
                        i_ora_charset_name => i_ora_charset_name,
                        i_filename => c_xml_file_name
                       );
    if l_xml_file_blob is not null then
      select workbook_name
        bulk collect into i_excel_workbook_names
        from xmltable(
              xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
              '//sheets/sheet'
              passing xmltype.createxml( l_xml_file_blob, c_xml_charset_id, null )
              columns
                workbook_name varchar2(255) path '@name' );
    end if;
  end query_excel_workbook_names;
  
--  procedure extract_date_styles(
--        p_xlsx           in blob,
--        p_format_codes   in out nocopy sys.ora_mining_varchar2_nt )
--    is
--        l_stylesheet blob;
--    begin
----if l_original then
----        l_stylesheet := file_adapter_data_imp_2.get_file(
--------        l_stylesheet := apex_zip.get_file_content(
----            p_zipped_blob => p_xlsx,
----            p_file_name   => 'xl/styles.xml' );
----else
--
--l_stylesheet := file_adapter_data_imp_2.file_blob_from_zipped_blob(
--            p_xlsx,
--            i_ora_charset_name,
--            'xl/styles.xml' );
----end if;            
--
--        if l_stylesheet is null then
--            return;
--        end if;
--
--        select lower( n.formatCode )
--        bulk collect into p_format_codes
--        from 
--            xmltable(
--                xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
--                '//cellXfs/xf'
--                passing xmltype.createxml( l_stylesheet, nls_charset_id('AL32UTF8'), null )
--                columns
--                   numFmtId number path '@numFmtId' ) s,
--            xmltable(
--                xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
--                '//numFmts/numFmt'
--                passing xmltype.createxml( l_stylesheet, nls_charset_id('AL32UTF8'), null )
--                columns
--                   formatCode varchar2(255) path '@formatCode',
--                   numFmtId   number        path '@numFmtId' ) n
--        where s.numFmtId = n.numFmtId ( + );
--
--    end extract_date_styles;
  
  
  procedure do_the_inserts (p_sheet_content in blob, p_sheet_name in varchar2,
  p_sheet_id in pls_integer,
  p_shared_strings in sys.ora_mining_varchar2_nt,
  p_format_codes in sys.ora_mining_varchar2_nt
  )
  is
    c_date_format   constant varchar2(10 char) := 'YYYY-MM-DD';
    l_worksheet     blob not null:=p_sheet_content;
    
        l_shared_strings      sys.ora_mining_varchar2_nt := p_shared_strings;
        l_format_codes        sys.ora_mining_varchar2_nt := p_format_codes;

       -- l_parsed_row          xlsx_row_t;
        l_first_row           boolean     := true;
        l_value               varchar2(32767);

        l_line#               pls_integer := 1;
        l_real_col#           pls_integer;
        l_row_has_content     boolean := false;
        
        l_num number;
        
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
  begin
  
  l_ftd_row:=null;  -- important!
  
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
                passing xmltype.createxml( l_worksheet, c_xml_charset_id, null )
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
--                l_parsed_row.line# := l_line#;
                l_ftd_row.row_number := -l_line#;
                if not l_first_row then
--                    pipe row( l_parsed_row );
    l_ftd_row.row_number := l_line#;--l_ridx;  
        l_ftd_row.ftd_id := i_ftd_id;
    l_ftd_row.frd_id := i_frd_id;
    l_ftd_row.fmd_id := i_fmd_id;
    l_ftd_row.timestamp_insert := systimestamp;
    l_ftd_row.sheet_name := p_sheet_name;
    l_ftd_row.sheet_id := p_sheet_id;
    insert into file_text_data values l_ftd_row;
    commit;                                                                     --TODO end!!!
                    l_line# := l_line# + 1;
--                    reset_row( l_parsed_row );
        l_ftd_row:=null;

                    l_row_has_content := false;
                else
                    l_first_row := false;
                end if;
            end if;
-- string? 
            if i.xlsx_col_type = 's' then
                if l_shared_strings.exists( i.xlsx_val + 1) then
                    l_value := l_shared_strings( i.xlsx_val + 1);
                else
                    l_value := '[Data Error: N/A]' ;
                end if;
            else -- date or number (xlsx_col_type is missing)
            
--            dbms_output.put_line(i.xlsx_val);
--            if l_shared_strings.exists( i.xlsx_val + 1) then
--              dbms_output.put_line(l_shared_strings( i.xlsx_val + 1));
--            end if;
            
            
                if l_format_codes.exists( i.xlsx_col_style + 1 ) and (
                    instr( l_format_codes( i.xlsx_col_style + 1 ), 'd' ) > 0 and
                    instr( l_format_codes( i.xlsx_col_style + 1 ), 'm' ) > 0 )
                then
                dbms_output.put_line(i.xlsx_val);
                dbms_output.put_line(DATE'1900-01-01');
                dbms_output.put_line(DATE'1900-01-01' - 2);
                                
--                    l_value := --to_char( 
--                    case when 62 > 61 then '|'||i.xlsx_val||'|' else 'b' end;

-- caution with nls!!!
l_num:=to_number(i.xlsx_val,'9999999D9999999', 'NLS_NUMERIC_CHARACTERS=''.,''');

                    l_value := to_char( 
                    case when l_num > 61 
                      then DATE'1900-01-01' - 2 + l_num
                      else DATE'1900-01-01' - 1 + l_num
            end, l_format_codes( i.xlsx_col_style + 1 ));--c_date_format );     -- format as in the original excel file
                else
                    l_value := i.xlsx_val;
                end if;
            end if;

            pragma inline( convert_ref_to_col#, 'YES' );
            l_real_col# := convert_ref_to_col#( i.xlsx_col );

            if l_real_col# between 1 and 200 then
                l_row_has_content := true;
            end if;

            case l_real_col#
              when 1 then l_ftd_row.c001:=l_value;
              when 2 then l_ftd_row.c002:=l_value;
              when 3 then l_ftd_row.c003:=l_value;
              when 4 then l_ftd_row.c004:=l_value;
              when 5 then l_ftd_row.c005:=l_value;
              when 6 then l_ftd_row.c006:=l_value;
              when 7 then l_ftd_row.c007:=l_value;
              when 8 then l_ftd_row.c008:=l_value;
              when 9 then l_ftd_row.c009:=l_value;
              when 10 then l_ftd_row.c010:=l_value;
              when 11 then l_ftd_row.c011:=l_value;
              when 12 then l_ftd_row.c012:=l_value;
              when 13 then l_ftd_row.c013:=l_value;
              when 14 then l_ftd_row.c014:=l_value;
              when 15 then l_ftd_row.c015:=l_value;
              when 16 then l_ftd_row.c016:=l_value;
              when 17 then l_ftd_row.c017:=l_value;
              when 18 then l_ftd_row.c018:=l_value;
              when 19 then l_ftd_row.c019:=l_value;
              when 20 then l_ftd_row.c020:=l_value;
              when 21 then l_ftd_row.c021:=l_value;
              when 22 then l_ftd_row.c022:=l_value;
              when 23 then l_ftd_row.c023:=l_value;
              when 24 then l_ftd_row.c024:=l_value;
              when 25 then l_ftd_row.c025:=l_value;
              when 26 then l_ftd_row.c026:=l_value;
              when 27 then l_ftd_row.c027:=l_value;
              when 28 then l_ftd_row.c028:=l_value;
              when 29 then l_ftd_row.c029:=l_value;
              when 30 then l_ftd_row.c030:=l_value;
              when 31 then l_ftd_row.c031:=l_value;
              when 32 then l_ftd_row.c032:=l_value;
              when 33 then l_ftd_row.c033:=l_value;
              when 34 then l_ftd_row.c034:=l_value;
              when 35 then l_ftd_row.c035:=l_value;
              when 36 then l_ftd_row.c036:=l_value;
              when 37 then l_ftd_row.c037:=l_value;
              when 38 then l_ftd_row.c038:=l_value;
              when 39 then l_ftd_row.c039:=l_value;
              when 40 then l_ftd_row.c040:=l_value;
              when 41 then l_ftd_row.c041:=l_value;
              when 42 then l_ftd_row.c042:=l_value;
              when 43 then l_ftd_row.c043:=l_value;
              when 44 then l_ftd_row.c044:=l_value;
              when 45 then l_ftd_row.c045:=l_value;
              when 46 then l_ftd_row.c046:=l_value;
              when 47 then l_ftd_row.c047:=l_value;
              when 48 then l_ftd_row.c048:=l_value;
              when 49 then l_ftd_row.c049:=l_value;
              when 50 then l_ftd_row.c050:=l_value;
              when 51 then l_ftd_row.c051:=l_value;
              when 52 then l_ftd_row.c052:=l_value;
              when 53 then l_ftd_row.c053:=l_value;
              when 54 then l_ftd_row.c054:=l_value;
              when 55 then l_ftd_row.c055:=l_value;
              when 56 then l_ftd_row.c056:=l_value;
              when 57 then l_ftd_row.c057:=l_value;
              when 58 then l_ftd_row.c058:=l_value;
              when 59 then l_ftd_row.c059:=l_value;
              when 60 then l_ftd_row.c060:=l_value;
              when 61 then l_ftd_row.c061:=l_value;
              when 62 then l_ftd_row.c062:=l_value;
              when 63 then l_ftd_row.c063:=l_value;
              when 64 then l_ftd_row.c064:=l_value;
              when 65 then l_ftd_row.c065:=l_value;
              when 66 then l_ftd_row.c066:=l_value;
              when 67 then l_ftd_row.c067:=l_value;
              when 68 then l_ftd_row.c068:=l_value;
              when 69 then l_ftd_row.c069:=l_value;
              when 70 then l_ftd_row.c070:=l_value;
              when 71 then l_ftd_row.c071:=l_value;
              when 72 then l_ftd_row.c072:=l_value;
              when 73 then l_ftd_row.c073:=l_value;
              when 74 then l_ftd_row.c074:=l_value;
              when 75 then l_ftd_row.c075:=l_value;
              when 76 then l_ftd_row.c076:=l_value;
              when 77 then l_ftd_row.c077:=l_value;
              when 78 then l_ftd_row.c078:=l_value;
              when 79 then l_ftd_row.c079:=l_value;
              when 80 then l_ftd_row.c080:=l_value;
              when 81 then l_ftd_row.c081:=l_value;
              when 82 then l_ftd_row.c082:=l_value;
              when 83 then l_ftd_row.c083:=l_value;
              when 84 then l_ftd_row.c084:=l_value;
              when 85 then l_ftd_row.c085:=l_value;
              when 86 then l_ftd_row.c086:=l_value;
              when 87 then l_ftd_row.c087:=l_value;
              when 88 then l_ftd_row.c088:=l_value;
              when 89 then l_ftd_row.c089:=l_value;
              when 90 then l_ftd_row.c090:=l_value;
              when 91 then l_ftd_row.c091:=l_value;
              when 92 then l_ftd_row.c092:=l_value;
              when 93 then l_ftd_row.c093:=l_value;
              when 94 then l_ftd_row.c094:=l_value;
              when 95 then l_ftd_row.c095:=l_value;
              when 96 then l_ftd_row.c096:=l_value;
              when 97 then l_ftd_row.c097:=l_value;
              when 98 then l_ftd_row.c098:=l_value;
              when 99 then l_ftd_row.c099:=l_value;
              when 100 then l_ftd_row.c100:=l_value;
              when 101 then l_ftd_row.c101:=l_value;
              when 102 then l_ftd_row.c102:=l_value;
              when 103 then l_ftd_row.c103:=l_value;
              when 104 then l_ftd_row.c104:=l_value;
              when 105 then l_ftd_row.c105:=l_value;
              when 106 then l_ftd_row.c106:=l_value;
              when 107 then l_ftd_row.c107:=l_value;
              when 108 then l_ftd_row.c108:=l_value;
              when 109 then l_ftd_row.c109:=l_value;
              when 110 then l_ftd_row.c110:=l_value;
              when 111 then l_ftd_row.c111:=l_value;
              when 112 then l_ftd_row.c112:=l_value;
              when 113 then l_ftd_row.c113:=l_value;
              when 114 then l_ftd_row.c114:=l_value;
              when 115 then l_ftd_row.c115:=l_value;
              when 116 then l_ftd_row.c116:=l_value;
              when 117 then l_ftd_row.c117:=l_value;
              when 118 then l_ftd_row.c118:=l_value;
              when 119 then l_ftd_row.c119:=l_value;
              when 120 then l_ftd_row.c120:=l_value;
              when 121 then l_ftd_row.c121:=l_value;
              when 122 then l_ftd_row.c122:=l_value;
              when 123 then l_ftd_row.c123:=l_value;
              when 124 then l_ftd_row.c124:=l_value;
              when 125 then l_ftd_row.c125:=l_value;
              when 126 then l_ftd_row.c126:=l_value;
              when 127 then l_ftd_row.c127:=l_value;
              when 128 then l_ftd_row.c128:=l_value;
              when 129 then l_ftd_row.c129:=l_value;
              when 130 then l_ftd_row.c130:=l_value;
              when 131 then l_ftd_row.c131:=l_value;
              when 132 then l_ftd_row.c132:=l_value;
              when 133 then l_ftd_row.c133:=l_value;
              when 134 then l_ftd_row.c134:=l_value;
              when 135 then l_ftd_row.c135:=l_value;
              when 136 then l_ftd_row.c136:=l_value;
              when 137 then l_ftd_row.c137:=l_value;
              when 138 then l_ftd_row.c138:=l_value;
              when 139 then l_ftd_row.c139:=l_value;
              when 140 then l_ftd_row.c140:=l_value;
              when 141 then l_ftd_row.c141:=l_value;
              when 142 then l_ftd_row.c142:=l_value;
              when 143 then l_ftd_row.c143:=l_value;
              when 144 then l_ftd_row.c144:=l_value;
              when 145 then l_ftd_row.c145:=l_value;
              when 146 then l_ftd_row.c146:=l_value;
              when 147 then l_ftd_row.c147:=l_value;
              when 148 then l_ftd_row.c148:=l_value;
              when 149 then l_ftd_row.c149:=l_value;
              when 150 then l_ftd_row.c150:=l_value;
              when 151 then l_ftd_row.c151:=l_value;
              when 152 then l_ftd_row.c152:=l_value;
              when 153 then l_ftd_row.c153:=l_value;
              when 154 then l_ftd_row.c154:=l_value;
              when 155 then l_ftd_row.c155:=l_value;
              when 156 then l_ftd_row.c156:=l_value;
              when 157 then l_ftd_row.c157:=l_value;
              when 158 then l_ftd_row.c158:=l_value;
              when 159 then l_ftd_row.c159:=l_value;
              when 160 then l_ftd_row.c160:=l_value;
              when 161 then l_ftd_row.c161:=l_value;
              when 162 then l_ftd_row.c162:=l_value;
              when 163 then l_ftd_row.c163:=l_value;
              when 164 then l_ftd_row.c164:=l_value;
              when 165 then l_ftd_row.c165:=l_value;
              when 166 then l_ftd_row.c166:=l_value;
              when 167 then l_ftd_row.c167:=l_value;
              when 168 then l_ftd_row.c168:=l_value;
              when 169 then l_ftd_row.c169:=l_value;
              when 170 then l_ftd_row.c170:=l_value;
              when 171 then l_ftd_row.c171:=l_value;
              when 172 then l_ftd_row.c172:=l_value;
              when 173 then l_ftd_row.c173:=l_value;
              when 174 then l_ftd_row.c174:=l_value;
              when 175 then l_ftd_row.c175:=l_value;
              when 176 then l_ftd_row.c176:=l_value;
              when 177 then l_ftd_row.c177:=l_value;
              when 178 then l_ftd_row.c178:=l_value;
              when 179 then l_ftd_row.c179:=l_value;
              when 180 then l_ftd_row.c180:=l_value;
              when 181 then l_ftd_row.c181:=l_value;
              when 182 then l_ftd_row.c182:=l_value;
              when 183 then l_ftd_row.c183:=l_value;
              when 184 then l_ftd_row.c184:=l_value;
              when 185 then l_ftd_row.c185:=l_value;
              when 186 then l_ftd_row.c186:=l_value;
              when 187 then l_ftd_row.c187:=l_value;
              when 188 then l_ftd_row.c188:=l_value;
              when 189 then l_ftd_row.c189:=l_value;
              when 190 then l_ftd_row.c190:=l_value;
              when 191 then l_ftd_row.c191:=l_value;
              when 192 then l_ftd_row.c192:=l_value;
              when 193 then l_ftd_row.c193:=l_value;
              when 194 then l_ftd_row.c194:=l_value;
              when 195 then l_ftd_row.c195:=l_value;
              when 196 then l_ftd_row.c196:=l_value;
              when 197 then l_ftd_row.c197:=l_value;
              when 198 then l_ftd_row.c198:=l_value;
              when 199 then l_ftd_row.c199:=l_value;
              when 200 then l_ftd_row.c200:=l_value;
            end case;

        end loop;
        if l_row_has_content then
--            l_parsed_row.line# := l_line#;
--            pipe row( l_parsed_row );
--    l_ridx:=l_ridx+1;        
    l_ftd_row.row_number := l_line#;--l_ridx;  
        l_ftd_row.ftd_id := i_ftd_id;
    l_ftd_row.frd_id := i_frd_id;
    l_ftd_row.fmd_id := i_fmd_id;
    l_ftd_row.timestamp_insert := systimestamp;
    l_ftd_row.sheet_name := p_sheet_name;
    l_ftd_row.sheet_id := p_sheet_id;
    insert into file_text_data values l_ftd_row;
    commit;                                                                     --TODO end!!!
        end if;
  end;
  
  begin
    dbms_output.put_line('start...');
    dbms_output.put_line('size complete => '||dbms_lob.getlength(i_blob_value));

    -- vc2 array bzgl. shared strings (?) via GESAMTblob holen (d.h. aktion vorlagern!)        
--    extract_shared_strings( 
--      p_xlsx    => i_blob_value,
--      p_strings => l_shared_strings );
--      
    query_excel_shared_strings(i_excel_shared_strings => l_shared_strings);
    dbms_output.put_line('shared strings => '||l_shared_strings.count);
    -- vc2 array bzgl. format codes (?) via GESAMTblob holen (d.h. aktion vorlagern!)
--    extract_date_styles( 
--      p_xlsx    => i_blob_value,
--      p_format_codes => l_format_codes );
--    dbms_output.put_line('format codes => '||l_format_codes.count);

    query_excel_format_codes(i_excel_format_codes => l_format_codes);

    query_excel_workbook_names(i_excel_workbook_names => l_workbook_names);

    l_sheets:=zipped_blob_to_files(i_blob_value, i_ora_charset_name, true);

    <<worksheet_loop>>
    for i in 1..l_sheets.count 
    loop
      dbms_output.put_line(l_sheets.count||'--'||l_sheets(i));
      -- => TODO
      --xml_query_and_insert_in_table();
--if l_original then      
--      
--      l_sheet_blob:= get_file
--    ( p_zipped_blob => i_blob
--    , p_file_name => l_sheets(i)
----    , p_encoding
--    );
--    
--    else
    l_sheet_blob:= file_blob_from_zipped_blob (
      i_zipped_blob =>  i_blob_value,--     in blob,
      i_ora_charset_name =>  i_ora_charset_name,--in varchar2,
      i_filename          => l_sheets(i));--in varchar2)
--end if;
    
      dbms_output.put_line('size sheet1 => '||dbms_lob.getlength(l_sheet_blob));
      
      
      do_the_inserts(
        p_sheet_content => l_sheet_blob,
        p_sheet_name => l_workbook_names(i),--regexp_substr(l_sheets(i), c_sheet_re, 1, 1, 'ix', 1),
        p_sheet_id => i,
        p_shared_strings => l_shared_strings,
        p_format_codes => l_format_codes);
      
    end loop worksheet_loop;
/*

1)    via get_file von "sheet1.xml" blob holen und diesen (? ggf. den ganzen blob
[dann wäre aber rausschneiden der einzelnen teile doppelt!])dann schicken an

2)    xlsx_parse( 
        p_xlsx_content   in blob, 
        p_worksheet_name in varchar2 default 'sheet1') 
      return xlsx_tab_t pipelined; 
      
      statt rückgabe xlsx_tab_t direkt insertin file-Text_data


---
        -- blob vom konkreten sheet
        l_worksheet := extract_worksheet( 
            p_xlsx           => l_xlsx_content,
            p_worksheet_name => p_worksheet_name );
        -- vc2 array bzgl. shared strings (?) via GESAMTblob holen (d.h. aktion vorlagern!)
        extract_shared_strings( 
            p_xlsx    => l_xlsx_content,
            p_strings => l_shared_strings );
        -- vc2 array bzgl. format codes (?) via GESAMTblob holen (d.h. aktion vorlagern!)
        extract_date_styles( 
            p_xlsx    => l_xlsx_content,
            p_format_codes => l_format_codes );

*/


--    l_ridx:=l_ridx+1;        
--    l_ftd_row.ftd_id := i_ftd_id;
--    l_ftd_row.frd_id := i_frd_id;
--    l_ftd_row.fmd_id := i_fmd_id;
--    l_ftd_row.timestamp_insert := systimestamp;
--    l_ftd_row.row_number := l_ridx;  
--
--    insert into file_text_data values l_ftd_row;
--    commit;
  end;
-------------------------------------------------------------------------------- 
  
  
  
  
  
  
  
  
--------------------------------------------------------------------------------  
 
-------------------------------------------------------------------------------- 
end imp_2_file_adapter_data;
/
