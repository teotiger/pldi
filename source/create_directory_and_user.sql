whenever sqlerror exit failure rollback
whenever oserror exit failure rollback
set echo off
set verify off
set feedback off

define pldi_directory = &1
define pldi_path_name = &2
define pldi_user      = &3
define pldi_password  = &4

create directory &pldi_directory as '&pldi_path_name';

create user &pldi_user identified by "&pldi_password";
grant connect, resource to &pldi_user;

grant all on directory &pldi_directory to &pldi_user;
