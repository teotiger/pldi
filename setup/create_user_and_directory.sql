whenever sqlerror exit failure rollback
whenever oserror exit failure rollback
set echo off
set verify off
set feedback off

define pldi_user      = &1
define pldi_password  = &2
define pldi_path_name = &3
define pldi_directory = &4

create user &pldi_user identified by "&pldi_password";
grant connect, resource, create procedure, create view to &pldi_user;

create directory &pldi_directory as '&pldi_path_name';

grant all on directory &pldi_directory to &pldi_user;