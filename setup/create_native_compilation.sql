prompt Compile code in native mode...
begin
  for i in (select name from user_plsql_object_settings where type='PACKAGE')
  loop
    execute immediate 'alter package '||
                      i.name||
                      ' compile plsql_code_type=native';
  end loop;
end;
/
prompt ...done!
prompt