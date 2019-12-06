whenever sqlerror exit failure rollback
whenever oserror exit failure rollback
set echo off
set verify off
set feedback off

define pldi_directory = &1
define pldi_user      = &2

drop directory &pldi_directory;
drop user &pldi_user cascade;
