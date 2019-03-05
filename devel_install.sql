drop table di.file_text_data purge;
drop table di.file_meta_data purge;
drop table di.file_raw_data purge;
drop table di.file_adapter_data purge;
drop sequence di.file_raw_data_seq;
drop sequence di.file_meta_data_seq;

prompt => Create tables
@@source/create_tables.sql
prompt => Reinstall Packages
@@source/di_util.pks
@@source/di_file_adapter1.pks
@@source/di_file_adapter2.pks
@@tests/di_util_test.pks
@@source/di_util.pkb
@@source/di_file_adapter1.pkb
@@source/di_file_adapter2.pkb
@@tests/di_util_test.pkb

prompt => Create some (sample) testdata
@@source/create_table_data.sql



select * from di.file_raw_data;
select * from di.file_meta_data;
select * from di.file_adapter_data;
select * from di.file_text_data;

declare
  l_ec integer;
begin
  l_ec:=di.di_util.insert_file_raw_data('countries.csv');
  sys.dbms_output.put_line(l_ec);
--  l_ec:=di.di_util.insert_file_raw_data('unemployment.csv');
--  sys.dbms_output.put_line(l_ec);
--  l_ec:=di.di_util.insert_file_raw_data('financial_sample.xlsx');
--  sys.dbms_output.put_line(l_ec);
end;
/