clear screen
prompt ************************
prompt PLDI INSTALLATION SCRIPT
prompt ************************
set echo off
set verify off
set feedback off
set define on

column 1 new_value 1 noprint

select null as "1" from dual where 1=0;

column pldi_directory new_value pldi_directory noprint

select coalesce('&&1','PLDI_FILES') pldi_directory from dual;

prompt Create tables...
@source/table/file_adapter_data.sql
@source/table/file_raw_data.sql
@source/table/file_meta_data.sql
@source/table/file_text_data.sql
prompt ...done!
prompt
prompt Create types, packages and views...
@@source/utils/utils.pks
@@source/api/file_adapter_data_api.pks
@@source/api/file_raw_data_api.pks
@@source/api/file_meta_data_api.pks
@@source/api/file_text_data_api.pks
@@source/api/file_adapter_data_api.pkb
@@source/api/file_raw_data_api.pkb
@@source/api/file_meta_data_api.pkb
@@source/api/file_text_data_api.pkb
@@source/utils/utils.pkb &&pldi_directory
@@source/adapter/imp_1_file_adapter_data.pks
@@source/adapter/imp_1_file_adapter_data.pkb
@@source/adapter/imp_2_file_adapter_data.pks
@@source/adapter/imp_2_file_adapter_data.pkb
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
