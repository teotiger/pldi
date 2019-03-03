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
@@source/di_file_adapter1.pks
@@source/di_file_adapter2.pks
@@tests/di_util_test.pks
@@source/di_util.pkb
@@source/di_file_adapter1.pkb
@@source/di_file_adapter2.pkb
@@tests/di_util_test.pkb
prompt => Install Trigger
@@source/file_raw_data_ai_trg.sql
prompt => Create some (sample) data
@@source/create_table_data.sql
prompt => Compile in native mode
alter package di_util compile plsql_code_type=native;
exit