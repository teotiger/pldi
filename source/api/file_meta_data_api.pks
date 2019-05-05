create or replace package file_meta_data_api authid definer 
as
    
  -- Add a new row to FILE_META_DATA.
  -- @A keyword or short description text.
  -- @...
  -- @...
  -- @... 
  -- @A character set name. If it is not a valid Oracle character set name, 
  -- PLDI will try to convert it to a valid one. If that failed, the return 
  -- value will the default AL32UTF8 (=UTF-8).
  -- @...
  -- @...
  -- @...
  procedure insert_row (
    i_keyword                       in file_meta_data.keyword%type,
    i_filename_match_filter         in file_meta_data.filename_match_filter%type,
    i_filter_is_regular_expression  in file_meta_data.filter_is_regular_expression%type,
    i_fad_id                        in file_meta_data.fad_id%type,
    i_character_set                 in file_meta_data.ora_charset_name%type,
    i_delimiter                     in file_meta_data.delimiter%type,
    i_enclosure                     in file_meta_data.enclosure%type,
    i_plsql_after_processing        in file_meta_data.plsql_after_processing%type);

  -- Modify an existing row in FILE_META_DATA.
  -- @The FILE_META_DATA_ID, a mandatory parameter.
  -- @A keyword or short description text (optional parameter)
  -- @...
  -- @...
  -- @...
  -- @A character set name (optional parameter). If it is not a valid Oracle character set name, PLDI will try to convert it to a valid one.
  -- @...
  -- @...
  -- @...
  procedure update_row (
    i_fmd_id                        in file_meta_data.fmd_id%type,
    i_keyword                       in file_meta_data.keyword%type,
    i_filename_match_filter         in file_meta_data.filename_match_filter%type,
    i_filter_is_regular_expression  in file_meta_data.filter_is_regular_expression%type,
    i_fad_id                        in file_meta_data.fad_id%type,
    i_character_set                 in file_meta_data.ora_charset_name%type,
    i_delimiter                     in file_meta_data.delimiter%type,
    i_enclosure                     in file_meta_data.enclosure%type,
    i_plsql_after_processing        in file_meta_data.plsql_after_processing%type);

  -- Remove a row from FILE_META_DATA.
  procedure delete_row (
    i_fmd_id  in file_meta_data.fmd_id%type);

end file_meta_data_api;
/