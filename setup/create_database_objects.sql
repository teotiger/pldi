prompt Create tables and sequences
@../source/data/file_raw_data.sql
@../source/data/file_status_data.sql
@../source/data/file_adapter_data.sql
@../source/data/file_meta_data.sql
@../source/data/file_text_data.sql
prompt ...done!
prompt

prompt Create api packages...
@../source/utils.pks
@../source/api/file_raw_data_api.pks
@../source/api/file_status_data_api.pks
@../source/api/file_adapter_data_api.pks
@../source/api/file_meta_data_api.pks
@../source/api/file_text_data_api.pks
@../source/adapter/imp_1_file_adapter_data.pks
-------->packages bodies...
@../source/utils.pkb &&pldi_directory &&pldi_max_bytes
@../source/api/file_raw_data_api.pkb
@../source/api/file_status_data_api.pkb
@../source/api/file_adapter_data_api.pkb
@../source/api/file_meta_data_api.pkb
@../source/api/file_text_data_api.pkb
@../source/adapter/imp_1_file_adapter_data.pkb
prompt ...done!
prompt

-- code coverage not working in native compilation mode
column script_name new_value l_db_script
set termout off
select decode(lower('&&pldi_tests_flag.'),'1','create_database_tests.sql','create_native_compilation.sql') script_name
  from dual;
set termout on
@@&&l_db_script.
