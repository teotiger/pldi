begin
  -- meta data
  file_meta_data_api.insert_row(
    i_keyword => 'simple standard csv with enclosure',
    i_filename_match_filter => 'countries\.[a-z]{3}',
    i_filter_is_regular_expression => 1,
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => '"',
    i_plsql_after_processing => null);
  file_meta_data_api.insert_row(
    i_keyword => 'simple standard csv without enclosure',
    i_filename_match_filter => '*employ*.csv',
    i_filter_is_regular_expression => 0,
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => ',',
    i_enclosure => null,
    i_plsql_after_processing => 'begin dbms_output.put_line(''file '||chr(38)||'1. done''); end;');
  file_meta_data_api.insert_row(
    i_keyword => 'tsv example',
    i_filename_match_filter => '*.tsv',
    i_filter_is_regular_expression => 0,
    i_fad_id => 1,
    i_character_set => 'AL32UTF8',
    i_delimiter => chr(9),
    i_enclosure => null,
    i_plsql_after_processing => null);
  file_meta_data_api.insert_row(
    i_keyword => 'big csv file',
    i_filename_match_filter => 'Eviction*.csv',
    i_filter_is_regular_expression => 0,
    i_fad_id => 1,
    i_character_set => 'al32UtF8',
    i_delimiter => ',',
    i_enclosure => '"',
    i_plsql_after_processing => null);
  file_meta_data_api.insert_row(
    i_keyword => 'coming soon...',                                              -- TODO
    i_filename_match_filter => 'categories.xlsx',
    i_filter_is_regular_expression => 0,
    i_fad_id => 2,
    i_character_set => 'utf-8',
    i_delimiter => null,
    i_enclosure => null,
    i_plsql_after_processing => null);
  file_meta_data_api.insert_row(
    i_keyword => 'simple excel file with only one worksheet',
    i_filename_match_filter => 'financial*.xlsx',
    i_filter_is_regular_expression => 0,
    i_fad_id => 2,
    i_character_set => 'utf-8',
    i_delimiter => null,
    i_enclosure => null,
    i_plsql_after_processing => null);
  file_meta_data_api.insert_row(
    i_keyword => 'coming soon...',                                              -- TODO
    i_filename_match_filter => 'sample-xlsx-file.xlsx',
    i_filter_is_regular_expression => 0,
    i_fad_id => 2,
    i_character_set => 'utf-8',
    i_delimiter => null,
    i_enclosure => null,
    i_plsql_after_processing => null);
end;
/
