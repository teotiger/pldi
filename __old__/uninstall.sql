clear screen
prompt **************************
prompt PLDI UNINSTALLATION SCRIPT
prompt **************************
set echo off
set verify off
set feedback off

column 1 new_value 1 noprint
column 2 new_value 2 noprint

select null as "1", null as "2" from dual where 1=0;

column pldi_directory new_value pldi_directory noprint
column pldi_user      new_value pldi_user      noprint

select coalesce('&&2','PLDI_FILES') pldi_directory,
       coalesce('&&1','PLDI') pldi_user       
  from dual;

prompt Drop directory and user...
@source/drop_directory_and_user.sql &&pldi_directory &&pldi_user
prompt ...done!

exit
