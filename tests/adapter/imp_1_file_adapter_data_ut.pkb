create or replace package body imp_1_file_adapter_data_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_filename constant file_raw_data.filename%type:='samplefile.txt';
  c_filedata constant varchar2(30 char):='Hello;World';
  c_keyword constant varchar2(30 char):='$?#*~';
  c_description_text constant varchar2(30 char):='Lorem Ipsum...';
  c_fad_id constant number:=1;
  c_utf8 constant varchar2(4 char):='UTF8';
  c_comma constant varchar2(1 char):=',';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure complete_csv_import_w_var_cols is
    c_csv_content constant varchar2(100 char):='1,Bob,Down
2,John,Dunbar,13/06/1945
3,Alice,Wunderland';
    l_ftd_id file_text_data.ftd_id%type;
    l_tmp number;
    l_actual sys_refcursor;
    l_expected sys_refcursor;
  begin
    file_meta_data_api.insert_row(
      i_fad_id => c_fad_id,
      i_filename_match_filter => c_filename,
      i_filter_is_regular_expression => 0,
      i_ora_charset_name => c_utf8,
      i_delimiter => c_comma,
      i_enclosure => null,
      i_plsql_after_processing => null,
      i_keyword => c_keyword,
      i_description_text => c_description_text);

    file_text_data_api.insert_rows(
      i_frd_id => file_raw_data_api.insert_row(
        i_filename => c_filename,
        i_blob_value => sys.utl_raw.cast_to_raw(c_csv_content)
      ),
      o_ftd_id => l_ftd_id,
      o_fmd_id => l_tmp,
      o_fad_id => l_tmp);

    open l_actual  for 
      select c001, c002, c003, c004 
        from file_text_data 
       where ftd_id=l_ftd_id
    order by row_number;

    open l_expected for 
      select '1' as c001, 'Bob' as c002, 'Down' as c003, null as c004 from dual union
      select '2', 'John', 'Dunbar', '13/06/1945' from dual union
      select '3', 'Alice', 'Wunderland', null from dual;

    ut.expect(l_actual).to_equal(l_expected);
  end complete_csv_import_w_var_cols;
--------------------------------------------------------------------------------
  procedure remove_csv_trailing_space_eol is
    c_csv_content constant varchar2(100 char):='1,Bob,Down
2,John,Dunbar,13/06/1945
3,Alice,Wunderland
    







';
    l_ftd_id file_text_data.ftd_id%type;
    l_tmp number;
    l_actual sys_refcursor;
    l_expected sys_refcursor;
  begin
    file_meta_data_api.insert_row(
      i_fad_id => c_fad_id,
      i_filename_match_filter => c_filename,
      i_filter_is_regular_expression => 0,
      i_ora_charset_name => c_utf8,
      i_delimiter => c_comma,
      i_enclosure => null,
      i_plsql_after_processing => null,
      i_keyword => c_keyword,
      i_description_text => c_description_text);

    file_text_data_api.insert_rows(
      i_frd_id => file_raw_data_api.insert_row(
        i_filename => c_filename,
        i_blob_value => sys.utl_raw.cast_to_raw(c_csv_content)
      ),
      o_ftd_id => l_ftd_id,
      o_fmd_id => l_tmp,
      o_fad_id => l_tmp);

    open l_actual  for 
      select c001, c002, c003, c004 
        from file_text_data 
       where ftd_id=l_ftd_id
    order by row_number;

    open l_expected for 
      select '1' as c001, 'Bob' as c002, 'Down' as c003, null as c004 from dual union
      select '2', 'John', 'Dunbar', '13/06/1945' from dual union
      select '3', 'Alice', 'Wunderland', null from dual;

    ut.expect(l_actual).to_equal(l_expected);
  end remove_csv_trailing_space_eol;
----------------------------------------------------------------------------------
  procedure multiline_cell_csv_import is
    c_csv constant clob:='4;"Lа ci darem
la mano";Don
11;"Fin ch''han 
dal 
vino";Giovanni';
    c_eol constant varchar2(1 char):=chr(10);
    c_enc constant varchar2(1 char):='"';
    l_expected sys.ora_mining_varchar2_nt:=sys.ora_mining_varchar2_nt(
      '4;"Lа ci darem'||chr(10)||'la mano";Don',
      '11;"Fin ch''han 
dal 
vino";Giovanni'
    );
    l_actual sys.ora_mining_varchar2_nt;
  begin
    l_actual:=imp_1_file_adapter_data.split_vc2(
      i_string_value => c_csv,
      i_delimiter => c_eol,
      i_enclosure => c_enc,
      i_trim_enclosure => false);
    ut.expect( anydata.convertcollection(l_actual) ).to_equal(
       anydata.convertcollection(l_expected) );
  end multiline_cell_csv_import;
----------------------------------------------------------------------------------
  procedure escaping_enclosure_char is
    c_csv constant clob
      :='Piano Sonata No.17 in D minor, Op.31, No.2|Ludwig van Beethoven|"It is usually referred to as "The Tempest" (or Der Sturm in his native German)"';
    c_del constant varchar2(1 char):='|';
    c_enc constant varchar2(1 char):='"';
    l_expected sys.ora_mining_varchar2_nt:=sys.ora_mining_varchar2_nt(
      'Piano Sonata No.17 in D minor, Op.31, No.2',
      'Ludwig van Beethoven',
      'It is usually referred to as "The Tempest" (or Der Sturm in his native German)'
      );
    l_actual sys.ora_mining_varchar2_nt;    
  begin
    l_actual:=imp_1_file_adapter_data.split_vc2(
      i_string_value => c_csv,
      i_delimiter => c_del,
      i_enclosure => c_enc);
    ut.expect( anydata.convertcollection(l_actual) ).to_equal(
       anydata.convertcollection(l_expected) );
  end escaping_enclosure_char;
--------------------------------------------------------------------------------
end imp_1_file_adapter_data_ut;
/
