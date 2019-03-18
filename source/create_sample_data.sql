begin
  -- adapter data
  file_adapter_data_api.insert_row(
    'CSV, TSV, TAB etc. -- delimiter-separated values (also DSV)');
  file_adapter_data_api.insert_row(
    'XLSX -- Office Open XML (OOXML or Microsoft Open XML');
  -- meta data
  file_meta_data_api.insert_row(
    i_keyword => 'simple standard csv with enclosure',
    i_filename_match_like => 'count*.csv',
    i_filename_match_regexp_like => 'countries\.[a-z]{3}',
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => '"',
    i_plsql_after_processing => null);
  file_meta_data_api.insert_row(
    i_keyword => 'simple standard csv without enclosure',
    i_filename_match_like => '*employ*.csv',
    i_filename_match_regexp_like => null,
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => null,
    i_plsql_after_processing => 'begin dbms_output.put_line(''file '||chr(38)||'1. done''); end;');
  file_meta_data_api.insert_row(
    i_keyword => 'tsv example',
    i_filename_match_like => '*.tsv',
    i_filename_match_regexp_like => null,
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => chr(9),
    i_enclosure => null,
    i_plsql_after_processing => null);
  file_meta_data_api.insert_row(
    i_keyword => 'big csv file',
    i_filename_match_like => 'Eviction*.csv',
    i_filename_match_regexp_like => null,
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => null,
    i_plsql_after_processing => null);
end;
/
