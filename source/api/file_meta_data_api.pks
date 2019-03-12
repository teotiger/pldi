create or replace package file_meta_data_api authid definer 
as

  -- Add a new row to FILE_META_DATA.
  procedure insert_row (
    i_keyword                     in file_meta_data.keyword%type,
    i_filename_match_like         in file_meta_data.filename_match_like%type,
    i_filename_match_regexp_like  in file_meta_data.filename_match_regexp_like%type,
    i_fad_id                      in file_meta_data.fad_id%type,
    i_character_set               in file_meta_data.character_set%type,
    i_delimiter                   in file_meta_data.delimiter%type,
    i_enclosure                   in file_meta_data.enclosure%type,
    i_plsql_after_processing      in file_meta_data.plsql_after_processing%type);

  -- Modify an existing row in FILE_META_DATA.
  procedure update_row (
    i_fmd_id                      in file_meta_data.fmd_id%type,
    i_keyword                     in file_meta_data.keyword%type,
    i_filename_match_like         in file_meta_data.filename_match_like%type,
    i_filename_match_regexp_like  in file_meta_data.filename_match_regexp_like%type,
    i_fad_id                      in file_meta_data.fad_id%type,
    i_character_set               in file_meta_data.character_set%type,
    i_delimiter                   in file_meta_data.delimiter%type,
    i_enclosure                   in file_meta_data.enclosure%type,
    i_plsql_after_processing      in file_meta_data.plsql_after_processing%type);

  -- Remove a row from FILE_META_DATA.
  procedure delete_row (
    i_fmd_id  in file_meta_data.fmd_id%type);

end file_meta_data_api;
/