create or replace package body imp_1_file_adapter_data_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_test_csv_filename constant varchar2(100 char):='unittest.csv';
--------------------------------------------------------------------------------
  procedure setup is
    l_fad_id_exists_fl number;
  begin
    file_meta_data_api.insert_row(
      i_keyword => 'test',
      i_filename_match_filter => c_test_csv_filename,
      i_filter_is_regular_expression => 0,
      i_fad_id => 1,
      i_character_set => 'UTF-8',
      i_delimiter => ',',
      i_enclosure => null,
      i_plsql_after_processing => null);
  end setup;
--------------------------------------------------------------------------------
  procedure teardown is
    l_ftd_id_max file_text_data.ftd_id%type;
  begin
    select max(ftd_id) 
      into l_ftd_id_max
      from file_text_data;
  
    delete from file_text_data where ftd_id>l_ftd_id_max-2; -- =2 tests
    commit;
    
    delete from file_meta_data where filename_match_filter=c_test_csv_filename;
    commit;
  end teardown;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure complete_csv_import_w_var_cols is
    c_csv_content constant varchar2(100 char):='1,Bob,Down
2,John,Dunbar,13/06/1945
3,Alice,Wunderland';
    c_utf_id number:=873;
    l_ftd number;
    l_actual sys_refcursor;
    l_expected sys_refcursor;
  begin
    l_ftd:=file_text_data_api.insert_rows (
            file_raw_data_api.insert_row(
              i_filename=>c_test_csv_filename,
              i_plain_text=>c_csv_content,
              i_ora_charset_id=>c_utf_id)
           );
    
    open l_actual  for 
      select c001, c002, c003, c004 
        from file_text_data 
       where ftd_id=l_ftd 
    order by row_number;

    open l_expected for 
      select '1' as c001, 'Bob' as c002, 'Down' as c003, null as c004 from dual union
      select '2', 'John', 'Dunbar', '13/06/1945' from dual union
      select '3', 'Alice', 'Wunderland', null from dual;

    ut.expect(l_actual).to_equal(l_expected);
  end complete_csv_import_w_var_cols;
--------------------------------------------------------------------------------
  procedure remove_csv_trailing_space_eol is
    l_csv_content clob:='1,Bob,Down
2,John,Dunbar,13/06/1945
3,Alice,Wunderland

  

';
    c_utf_id number:=873;
    l_ftd number;
    l_actual sys_refcursor;
    l_expected sys_refcursor;
  begin
    l_ftd:=file_text_data_api.insert_rows (
            file_raw_data_api.insert_row(
              i_filename=>c_test_csv_filename,
              i_plain_text=>l_csv_content,
              i_ora_charset_id=>c_utf_id)
           );
    
    open l_actual  for 
      select c001, c002, c003, c004 
        from file_text_data 
       where ftd_id=l_ftd 
    order by row_number;

    open l_expected for 
      select '1' as c001, 'Bob' as c002, 'Down' as c003, null as c004 from dual union
      select '2', 'John', 'Dunbar', '13/06/1945' from dual union
      select '3', 'Alice', 'Wunderland', null from dual;

    ut.expect(l_actual).to_equal(l_expected);
  end remove_csv_trailing_space_eol;
--------------------------------------------------------------------------------
  procedure multiline_cell_csv_import is
    c_csv constant clob:=q'~4;"Lа ci darem 
la mano";Don
11;"Fin ch'han 
dal 
vino";Giovanni~';
    c_eol constant varchar2(1 char):=chr(10);
    c_enc constant varchar2(1 char):='"';
    l_expected sys.ora_mining_varchar2_nt:=sys.ora_mining_varchar2_nt(
      q'~4;"Lа ci darem 
la mano";Don~',
      q'~11;"Fin ch'han 
dal 
vino";Giovanni~'
    );
    l_actual sys.ora_mining_varchar2_nt;
  begin
    l_actual:=utils.split_varchar2(
      i_string_value => c_csv,
      i_delimiter => c_eol,
      i_enclosure => c_enc);
    ut.expect( anydata.convertcollection(l_actual) ).to_equal(
       anydata.convertcollection(l_expected) );
  end;
--------------------------------------------------------------------------------
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
    l_actual:=utils.split_varchar2(
      i_string_value => c_csv,
      i_delimiter => c_del,
      i_enclosure => c_enc);
    ut.expect( anydata.convertcollection(l_actual) ).to_equal(
       anydata.convertcollection(l_expected) );
  end;
--------------------------------------------------------------------------------
end imp_1_file_adapter_data_ut;
/
