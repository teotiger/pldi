clear screen

prompt ************************
prompt PLDI INSTALLATION SCRIPT
prompt ************************

set echo off
set verify off
set feedback off

column 1 new_value 1 noprint
column 2 new_value 2 noprint
column 3 new_value 3 noprint
column 4 new_value 4 noprint

select null as "1", null as "2", null as "3", null as "4" 
  from dual 
 where 1=0;
  
column pldi_user      new_value pldi_user      noprint
column pldi_password  new_value pldi_password  noprint
column pldi_directory new_value pldi_directory noprint
column pldi_path_name new_value pldi_path_name noprint

select coalesce('&&1','PLDI') pldi_user,
       coalesce('&&2','pldi') pldi_password,
       coalesce('&&3','PLDI_FILES') pldi_directory,
       coalesce('&&4','/media/sf_debora') pldi_path_name
  from dual;

prompt Create user and directory...
@@source/create_user.sql pldi pldi &&pldi_directory &&pldi_path_name
--@@source/create_user.sql &&pldi_user &&pldi_password &&pldi_directory &&pldi_path_name
prompt ...done!

-- switching to new schema
alter session set current_schema = pldi;

prompt Create tables...
@@source/file_adapter_data.sql
@@source/file_raw_data.sql
@@source/file_meta_data.sql
@@source/file_text_data.sql
prompt ...done!

prompt Create types, packages and views...
@@source/varchar2_tt.tps
@@source/utils.pks
@@source/utils.pkb &&pldi_directory
@@source/api/file_adapter_data_api.pks
@@source/api/file_raw_data_api.pks
@@source/api/file_meta_data_api.pks
@@source/api/file_text_data_api.pks
@@source/api/file_adapter_data_api.pkb
@@source/api/file_raw_data_api.pkb
@@source/api/file_meta_data_api.pkb
@@source/api/file_text_data_api.pkb
@@tests/utils_test.pks
@@tests/utils_test.pkb
@@source/adapter/file_adapter_data_imp_1.pks
@@source/adapter/file_adapter_data_imp_2.pks
@@source/adapter/file_adapter_data_imp_1.pkb
@@source/adapter/file_adapter_data_imp_2.pkb
@@source/file_content_v.vw
prompt ...done!

prompt Create sample data...
@@source/sample_data.sql
prompt ...done!

exit