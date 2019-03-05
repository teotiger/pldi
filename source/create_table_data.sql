-- FILE_ADAPTER_DATA => todo via api in di_util!
insert into di.file_adapter_data 
  values (1, 'CSV, TSV, TAB etc. -- delimiter-separated values (also DSV)');
insert into di.file_adapter_data 
  values (2, 'XLSX -- Office Open XML (OOXML or Microsoft Open XML');
commit;

-- FILE_META_DATA
declare
  l_ec integer;
begin
  -- meta data
  di.di_util.insert_file_meta_data(
    i_keyword => 'simple standard csv with enclosure',
    i_filename_match => 'count*.csv',
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => '"');
  di.di_util.insert_file_meta_data(
    i_keyword => 'simple standard csv without enclosure',
    i_filename_match => '*employ*.csv',
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => null);
end;
/
