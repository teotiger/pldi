clear screen
prompt ************************
prompt PLDI INSTALLATION SCRIPT
prompt ************************
set echo off
set verify off
set feedback off

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
@@tests/utils_test.pks
@@tests/utils_test.pkb
@@source/adapter/file_adapter_data_imp_1.pks
@@source/adapter/file_adapter_data_imp_1.pkb
@@source/utils/file_content_v.vw
prompt ...done!

exit
