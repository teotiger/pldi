--*************************
-- PLDI INSTALLATION SCRIPT
--*************************

  --> TODO via prompt min. Direcotry pfad mitnehmen (ggf. user?) s.a. /home/alegria/Development/PLSQL/plsql/work/setl/

clear screen;
set scan off;

prompt => Create user di
@@source/create_user.sql
prompt => Create tables
@@source/create_tables.sql
prompt => Create directory
@@source/create_directory.sql
prompt => Set plsql_optimize_level to 3
alter session set plsql_optimize_level=3;
alter session set plsql_warnings = 'ENABLE:ALL', 'DISABLE:(6005,6009,7206,7202)';
prompt => Install Packages
@@source/di_util.pks
@@source/di_util.pkb
@@tests/di_util_test.pks
@@tests/di_util_test.pkb

@@source/api/file_meta_data_api.pks
@@source/api/file_adapter_data_api.pks
@@source/api/file_meta_data_api.pkb
@@source/api/file_adapter_data_api.pkb

@@source/adapter/file_adapter_data_imp_1.pks
@@source/adapter/file_adapter_data_imp_2.pks
@@source/adapter/file_adapter_data_imp_1.pkb
@@source/adapter/file_adapter_data_imp_2.pkb

prompt => Create some (sample) data
@@source/create_table_data.sql
prompt => Compile in native mode
alter package di_util compile plsql_code_type=native;                           -- TODO -> all in native?
exit