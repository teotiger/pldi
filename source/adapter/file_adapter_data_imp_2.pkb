create or replace package body file_adapter_data_imp_2
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
    c_xml_charset_id constant varchar2(30 char):=nls_charset_id('AL32UTF8');
    l_ridx    simple_integer:=0;
    l_ftd_row file_text_data%rowtype;
    l_sheets  sys.ora_mining_varchar2_nt;
    l_sheet_blob blob;
    l_shared_strings  sys.ora_mining_varchar2_nt;
    l_format_codes  sys.ora_mining_varchar2_nt;

--  procedure extract_shared_strings(
--        p_xlsx           in blob,
--        p_strings        in out nocopy sys.ora_mining_varchar2_nt )
--    is
--        l_shared_strings blob;
--    begin
--
----if l_original then
----l_shared_strings := file_adapter_data_imp_2.get_file(
----  --l_shared_strings := apex_zip.get_file_content(
----            p_zipped_blob => p_xlsx,
----            p_file_name   => 'xl/sharedStrings.xml' );
----else
--l_shared_strings := file_adapter_data_imp_2.file_blob_from_zipped_blob(
--            p_xlsx,
--            i_ora_charset_name,
--            'xl/sharedStrings.xml' );
----end if;
--
--dbms_output.put_line('DBG - 1 pass');
--        if l_shared_strings is null then
--            return;
--        end if;
--dbms_output.put_line('DBG - 2 pass');
--
--        select shared_string
--          bulk collect into p_strings
--          from xmltable(
--              xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
--              '//si'
--              passing xmltype.createxml( l_shared_strings, nls_charset_id('AL32UTF8'), null )
--              columns
--                 shared_string varchar2(4000)   path 't/text()' );
--
--dbms_output.put_line('DBG - 3 pass');
--
--
--    end extract_shared_strings;
  
  procedure query_excel_shared_strings(
    i_excel_shared_strings in out nocopy sys.ora_mining_varchar2_nt)
  is
    c_xml_file_name constant varchar2(30 char):='xl/sharedStrings.xml';
    l_xml_file_blob blob;
  begin
    l_xml_file_blob := file_adapter_data_imp_2.file_blob_from_zipped_blob(
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
    l_xml_file_blob := file_adapter_data_imp_2.file_blob_from_zipped_blob(
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
                numFmtId number path '@numFmtId' ) s,
             xmltable(
              xmlnamespaces( default 'http://schemas.openxmlformats.org/spreadsheetml/2006/main' ),
              '//numFmts/numFmt'
              passing xmltype.createxml( l_xml_file_blob, c_xml_charset_id, null )
              columns
                formatCode varchar2(255) path '@formatCode',
                numFmtId   number        path '@numFmtId' ) n
        where s.numFmtId = n.numFmtId ( + );
    end if;
  end query_excel_format_codes;
  
  
  
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
  p_shared_strings in sys.ora_mining_varchar2_nt,
  p_format_codes in sys.ora_mining_varchar2_nt
  )
  is
    c_date_format   constant varchar2(255) := 'YYYY-MM-DD';
    l_worksheet     blob not null:=p_sheet_content;
    
        l_shared_strings      sys.ora_mining_varchar2_nt := p_shared_strings;
        l_format_codes        sys.ora_mining_varchar2_nt := p_format_codes;

       -- l_parsed_row          xlsx_row_t;
        l_first_row           boolean     := true;
        l_value               varchar2(32767);

        l_line#               pls_integer := 1;
        l_real_col#           pls_integer;
        l_row_has_content     boolean := false;
        
        
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
    insert into file_text_data values l_ftd_row;
    commit;
                    l_line# := l_line# + 1;
--                    reset_row( l_parsed_row );
        l_ftd_row:=null;

                    l_row_has_content := false;
                else
                    l_first_row := false;
                end if;
            end if;
--
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
                    l_value := to_char( 
                    case when i.xlsx_val > 61 
                      then DATE'1900-01-01' - 2 + i.xlsx_val
                      else DATE'1900-01-01' - 1 + i.xlsx_val
            end, c_date_format );
                else
                    l_value := i.xlsx_val;
                end if;
            end if;

            pragma inline( convert_ref_to_col#, 'YES' );
            l_real_col# := convert_ref_to_col#( i.xlsx_col );

            if l_real_col# between 1 and 50 then
                l_row_has_content := true;
            end if;
--

            case l_real_col#
              when 1 then l_ftd_row.c001:=l_value;--trimit(l_cell_arr(j));
              when 2 then l_ftd_row.c002:=l_value;--trimit(l_cell_arr(j));
              when 3 then l_ftd_row.c003:=l_value;--trimit(l_cell_arr(j));
              when 4 then l_ftd_row.c004:=l_value;--trimit(l_cell_arr(j));
              when 5 then l_ftd_row.c005:=l_value;--trimit(l_cell_arr(j));
            else null;
            end case;
--            -- we currently support 50 columns - but this can easily be increased. Just add additional lines
--            -- as follows:
--            -- when l_real_col# = {nn} then l_parsed_row.col{nn} := l_value;
--            case
--                when l_real_col# =  1 then l_parsed_row.col01 := l_value;
--                when l_real_col# =  2 then l_parsed_row.col02 := l_value;
--                when l_real_col# =  3 then l_parsed_row.col03 := l_value;
--                when l_real_col# =  4 then l_parsed_row.col04 := l_value;
--                when l_real_col# =  5 then l_parsed_row.col05 := l_value;
--                when l_real_col# =  6 then l_parsed_row.col06 := l_value;
--                when l_real_col# =  7 then l_parsed_row.col07 := l_value;
--                when l_real_col# =  8 then l_parsed_row.col08 := l_value;
--                when l_real_col# =  9 then l_parsed_row.col09 := l_value;
--                when l_real_col# = 10 then l_parsed_row.col10 := l_value;
--                when l_real_col# = 11 then l_parsed_row.col11 := l_value;
--                when l_real_col# = 12 then l_parsed_row.col12 := l_value;
--                when l_real_col# = 13 then l_parsed_row.col13 := l_value;
--                when l_real_col# = 14 then l_parsed_row.col14 := l_value;
--                when l_real_col# = 15 then l_parsed_row.col15 := l_value;
--                when l_real_col# = 16 then l_parsed_row.col16 := l_value;
--                when l_real_col# = 17 then l_parsed_row.col17 := l_value;
--                when l_real_col# = 18 then l_parsed_row.col18 := l_value;
--                when l_real_col# = 19 then l_parsed_row.col19 := l_value;
--                when l_real_col# = 20 then l_parsed_row.col20 := l_value;
--                when l_real_col# = 21 then l_parsed_row.col21 := l_value;
--                when l_real_col# = 22 then l_parsed_row.col22 := l_value;
--                when l_real_col# = 23 then l_parsed_row.col23 := l_value;
--                when l_real_col# = 24 then l_parsed_row.col24 := l_value;
--                when l_real_col# = 25 then l_parsed_row.col25 := l_value;
--                when l_real_col# = 26 then l_parsed_row.col26 := l_value;
--                when l_real_col# = 27 then l_parsed_row.col27 := l_value;
--                when l_real_col# = 28 then l_parsed_row.col28 := l_value;
--                when l_real_col# = 29 then l_parsed_row.col29 := l_value;
--                when l_real_col# = 30 then l_parsed_row.col30 := l_value;
--                when l_real_col# = 31 then l_parsed_row.col31 := l_value;
--                when l_real_col# = 32 then l_parsed_row.col32 := l_value;
--                when l_real_col# = 33 then l_parsed_row.col33 := l_value;
--                when l_real_col# = 34 then l_parsed_row.col34 := l_value;
--                when l_real_col# = 35 then l_parsed_row.col35 := l_value;
--                when l_real_col# = 36 then l_parsed_row.col36 := l_value;
--                when l_real_col# = 37 then l_parsed_row.col37 := l_value;
--                when l_real_col# = 38 then l_parsed_row.col38 := l_value;
--                when l_real_col# = 39 then l_parsed_row.col39 := l_value;
--                when l_real_col# = 40 then l_parsed_row.col40 := l_value;
--                when l_real_col# = 41 then l_parsed_row.col41 := l_value;
--                when l_real_col# = 42 then l_parsed_row.col42 := l_value;
--                when l_real_col# = 43 then l_parsed_row.col43 := l_value;
--                when l_real_col# = 44 then l_parsed_row.col44 := l_value;
--                when l_real_col# = 45 then l_parsed_row.col45 := l_value;
--                when l_real_col# = 46 then l_parsed_row.col46 := l_value;
--                when l_real_col# = 47 then l_parsed_row.col47 := l_value;
--                when l_real_col# = 48 then l_parsed_row.col48 := l_value;
--                when l_real_col# = 49 then l_parsed_row.col49 := l_value;
--                when l_real_col# = 50 then l_parsed_row.col50 := l_value;
--                else null;
--            end case;

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
    l_ftd_row.sheet_name := p_sheet_name||'last';
    insert into file_text_data values l_ftd_row;
    commit;
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
        p_sheet_name => regexp_substr(l_sheets(i), '(([A-Za-z0-9])*.xml)'),
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
end file_adapter_data_imp_2;
/
