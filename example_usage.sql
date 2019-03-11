--select * from user_objects;
set serveroutput on;

declare
  x integer;
begin
  x:=pldi_util.insert_file_raw_data('countries.csv','PLDI_FILES');
  dbms_output.put_line(x);
end;
/

select * from file_text_data;