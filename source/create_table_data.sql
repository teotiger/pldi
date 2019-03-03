--insert into di.file_adapter_data 
--  values (1, 'CSV, TSV, TAB etc. -- delimiter-separated values (also DSV)');
--insert into di.file_adapter_data 
--  values (2, 'XLSX -- Office Open XML (OOXML or Microsoft Open XML');
--commit;

declare
  l_ec integer;
begin
  -- meta data
  di.di_util.insert_file_meta_data(
    i_keyword => 'simple standard csv with enclosure',
    i_filename_match => 'count*.csv',
    i_fad_id => 1,
    i_character_encoding => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => '"');
  di.di_util.insert_file_meta_data(
    i_keyword => 'simple standard csv without enclosure',
    i_filename_match => '*employ*.csv',
    i_fad_id => 1,
    i_character_encoding => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => null);
  -- blob data
  l_ec:=di.di_util.insert_file_raw_data('countries.csv');
  sys.dbms_output.put_line(l_ec);
  l_ec:=di.di_util.insert_file_raw_data('unemployment.csv');
  sys.dbms_output.put_line(l_ec);
  l_ec:=di.di_util.insert_file_raw_data('financial_sample.xlsx');
  sys.dbms_output.put_line(l_ec);
end;
/

declare
  l_ec integer;
begin
  l_ec:=di.di_util.insert_file_raw_data('countries.csv');
  sys.dbms_output.put_line(l_ec);
end;
/
--
--declare
--  l_ec integer;
--begin
--  l_ec:=di.di_util.insert_file_raw_data('countries.csv');
--  sys.dbms_output.put_line(l_ec);
--end;
--/
--
--
-- select * from file_text_data;
-- 
-- select * from file_raw_data;
-- 
-- select * from file_meta_data;
-- 
-- select * from file_adapter_data;