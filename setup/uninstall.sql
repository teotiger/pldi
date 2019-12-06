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

column pldi_user      new_value pldi_user      noprint
column pldi_directory new_value pldi_directory noprint

select coalesce('&&1','PLDI') pldi_user,
       coalesce('&&2','PLDI_FILES') pldi_directory
  from dual;

prompt Drop user and directory...
drop user &pldi_user cascade;
drop directory &pldi_directory;
prompt ...done!

exit
