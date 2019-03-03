--***************************
-- PLDI UNINSTALLATION SCRIPT
--***************************
clear screen;
set scan off;
prompt => Drop directory
@@source/drop_directory.sql
prompt => Drop user di
@@source/drop_user.sql
exit