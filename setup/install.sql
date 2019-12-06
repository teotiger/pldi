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
column 4 new_value 4 noprint
column 5 new_value 5 noprint
column 6 new_value 6 noprint

select null as "1", null as "2", null as "3",
       null as "4", null as "5", null as "6"
  from dual 
 where 1=0;

column pldi_user       new_value pldi_user       noprint
column pldi_password   new_value pldi_password   noprint
column pldi_path_name  new_value pldi_path_name  noprint
column pldi_directory  new_value pldi_directory  noprint
column pldi_max_bytes  new_value pldi_max_bytes  noprint
column pldi_tests_flag new_value pldi_tests_flag noprint

select coalesce('&&1','PLDI') pldi_user,
       coalesce('&&2','pldi') pldi_password,
       coalesce('&&3','/opt/ora_files') pldi_path_name,
       coalesce('&&4','PLDI_FILES') pldi_directory,
       coalesce('&&5','8192') pldi_max_bytes,
--       coalesce('&&6','0') pldi_tests_flag

-- TODO


       coalesce('&&6','1') pldi_tests_flag
  from dual;

prompt Create user and directory...
@create_user_and_directory.sql &&pldi_user &&pldi_password &&pldi_path_name &&pldi_directory
prompt ...done!
prompt

alter session set current_schema = &&pldi_user;
@create_database_objects.sql &&pldi_directory &&pldi_max_bytes &&pldi_tests_flag

exit
