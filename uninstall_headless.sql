clear screen
prompt **************************
prompt PLDI UNINSTALLATION SCRIPT
prompt **************************

prompt Drop tables...
drop table file_text_data purge;
drop table file_meta_data purge;
drop table file_adapter_data purge;
drop table file_raw_data purge;
prompt ...done!

prompt Drop packages, sequences and views...
begin
  for i in (
  select 'drop '||object_type||' '||object_name stmt 
    from user_objects 
   where object_type not like '% %'
  ) loop
    execute immediate i.stmt;  
  end loop;
end;
/
prompt ...done!

exit
