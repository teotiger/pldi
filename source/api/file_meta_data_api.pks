create or replace package di.file_meta_data_api authid definer 
as

  -- insert...
  procedure insert_row (
    i_keyword         in file_meta_data.keyword%type,
    i_filename_match  in file_meta_data.filename_match%type,
    i_fad_id          in file_meta_data.fad_id%type,
    i_character_set   in file_meta_data.character_set%type,
    i_delimiter       in file_meta_data.delimiter%type,
    i_enclosure       in file_meta_data.enclosure%type);

   -- update...
  procedure update_file_meta_data (
    i_fmd_id          in file_meta_data.fmd_id%type,
    i_keyword         in file_meta_data.keyword%type,
    i_filename_match  in file_meta_data.filename_match%type,
    i_fad_id          in file_meta_data.fad_id%type,
    i_character_set   in file_meta_data.character_set%type,
    i_delimiter       in file_meta_data.delimiter%type,
    i_enclosure       in file_meta_data.enclosure%type);

end file_meta_data_api;
/