begin
  -- adapter data
  &&pldi_user..file_adapter_data_api.insert_row(
    'CSV, TSV, TAB etc. -- delimiter-separated values (also DSV)');
  &&pldi_user..file_adapter_data_api.insert_row(
    'XLSX -- Office Open XML (OOXML or Microsoft Open XML');
  -- meta data
  &&pldi_user..file_meta_data_api.insert_row(
    i_keyword => 'simple standard csv with enclosure',
    i_filename_match => 'count*.csv',
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => '"');
  &&pldi_user..file_meta_data_api.insert_row(
    i_keyword => 'simple standard csv without enclosure',
    i_filename_match => '*employ*.csv',
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => null);
end;
/
