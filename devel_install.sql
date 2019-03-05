drop table di.file_text_data purge;
drop table di.file_meta_data purge;
drop table di.file_raw_data purge;
drop table di.file_adapter_data purge;
drop sequence di.file_meta_data_seq;
drop sequence di.file_raw_data_seq;
drop sequence di.file_adapter_data_seq;

prompt => Create tables
@@source/create_tables.sql
prompt => Reinstall Packages

@@source/di_util.pks
@@source/di_util.pkb
@@tests/di_util_test.pks
@@tests/di_util_test.pkb

@@source/api/file_meta_data_api.pks
@@source/api/file_adapter_data_api.pks
@@source/api/file_meta_data_api.pkb
@@source/api/file_adapter_data_api.pkb

@@source/adapter/file_adapter_data_imp_1.pks
@@source/adapter/file_adapter_data_imp_2.pks
@@source/adapter/file_adapter_data_imp_1.pkb
@@source/adapter/file_adapter_data_imp_2.pkb


prompt => Create some (sample) testdata
@@source/create_table_data.sql


select * from di.file_raw_data;
select * from di.file_meta_data;
select * from di.file_adapter_data;
select * from di.file_text_data;

select substr(x.object_name,1,instr(x.object_name,'_',1,2)-1) as parent, x.* from dba_objects x where owner='DI' order by 3;

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