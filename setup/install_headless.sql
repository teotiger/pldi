clear screen
prompt ************************
prompt PLDI INSTALLATION SCRIPT
prompt ************************
set echo off
set verify off
set feedback off
set define on

column 1 new_value 1 noprint
column 2 new_value 2 noprint
column 3 new_value 3 noprint

select null as "1", null as "2", null as "3" from dual where 1=0;

column pldi_directory new_value pldi_directory noprint
column pldi_max_bytes new_value pldi_max_bytes noprint
column pldi_tests_flag new_value pldi_tests_flag noprint

select coalesce('&&1','PLDI_FILES') pldi_directory,
       coalesce('&&2','8192') pldi_max_bytes,
       
       
--       coalesce('&&3','0') pldi_tests_flag                                      -- TODO !!!!!!!!!!!!!!!!!
       
       
       coalesce('&&3','1') pldi_tests_flag
  from dual;

@create_database_objects.sql &&pldi_directory &&pldi_max_bytes &&pldi_tests_flag

prompt Create adapter data...
begin
  file_adapter_data_api.insert_row(i_keyword => 'CSV',
                                   i_description_text => 'CSV, TSV, TAB etc. -- delimiter-separated values (also DSV).');
  file_adapter_data_api.insert_row(i_keyword => 'Excel',
                                   i_description_text => 'XLSX -- Office Open XML (OOXML or Microsoft Open XML) -- pure PLSQL');
  file_adapter_data_api.insert_row(i_keyword => 'Excel',
                                   i_description_text => 'XLSX -- Office Open XML (OOXML or Microsoft Open XML) -- with some SQL queries');
  commit;
end;
/
prompt ...done!

/*
prompt Create tables...
@source/table/file_adapter_data.sql
@source/table/file_raw_data.sql
@source/table/file_meta_data.sql
@source/table/file_text_data.sql
@source/table/file_processing_data.sql
prompt ...done!
prompt
prompt Create types, packages and views...
@@source/utils/utils.pks
@@source/api/file_adapter_data_api.pks
@@source/api/file_raw_data_api.pks
@@source/api/file_meta_data_api.pks
@@source/api/file_text_data_api.pks
@@source/api/file_processing_data_api.pks
@@source/api/file_adapter_data_api.pkb
@@source/api/file_raw_data_api.pkb
@@source/api/file_meta_data_api.pkb
@@source/api/file_text_data_api.pkb
@@source/api/file_processing_data_api.pkb
@@source/utils/utils.pkb &&pldi_directory
@@source/adapter/imp_1_file_adapter_data.pks
@@source/adapter/imp_1_file_adapter_data.pkb
@@source/adapter/imp_2_file_adapter_data.pks
@@source/adapter/imp_2_file_adapter_data.pkb
@@source/adapter/imp_3_file_adapter_data.pks
@@source/adapter/imp_3_file_adapter_data.pkb
@@source/utils/file_content_v.vw
prompt ...done!
prompt
prompt Create default settings and unit test packages...
@@source/utils/default_pldi_settings.sql
@@tests/file_meta_data_api_ut.pks
@@tests/file_meta_data_api_ut.pkb
@@tests/file_raw_data_api_ut.pks
@@tests/file_raw_data_api_ut.pkb
@@tests/imp_1_file_adapter_data_ut.pks
@@tests/imp_1_file_adapter_data_ut.pkb
prompt ...done!
*/