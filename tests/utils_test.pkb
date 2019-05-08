create or replace package body utils_test as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_test_csv_filename constant varchar2(100 char):='unittest.csv';
--------------------------------------------------------------------------------
  procedure setup is
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
  begin
    delete from file_text_data where ftd_id=(select max(ftd_id) 
                                               from file_text_data);
    commit;
    
    delete from file_meta_data where filename_match_filter=c_test_csv_filename;
    commit;
  end teardown;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_dir is
  begin
    file_raw_data_api.insert_row('samplefile.txt', '$?#*~');
  end insert_file_non_existing_dir;
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_file is
  begin
    file_raw_data_api.insert_row('$?#*~');
  end insert_file_non_existing_file;
--------------------------------------------------------------------------------
  procedure imp_1_adapter_csv_w_var_cols is
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
    
    --abfrage mit dieser ftd und cursor vergleich
    open l_actual  for 
      select c001, c002, c003, c004 from file_text_data where ftd_id=l_ftd order by row_number;

    open l_expected for 
      select '1' as c001, 'Bob' as c002, 'Down' as c003, null as c004 from dual union
      select '2', 'John', 'Dunbar', '13/06/1945' from dual union
      select '3', 'Alice', 'Wunderland', null from dual;

    ut.expect(l_actual).to_equal(l_expected);
  end imp_1_adapter_csv_w_var_cols;
--------------------------------------------------------------------------------
end utils_test;
/
