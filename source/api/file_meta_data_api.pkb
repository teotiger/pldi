create or replace package body &&pldi_user..file_meta_data_api
as
--------------------------------------------------------------------------------
  procedure insert_row (
    i_keyword         in file_meta_data.keyword%type,
    i_filename_match  in file_meta_data.filename_match%type,
    i_fad_id          in file_meta_data.fad_id%type,
    i_character_set   in file_meta_data.character_set%type,
    i_delimiter       in file_meta_data.delimiter%type,
    i_enclosure       in file_meta_data.enclosure%type)
  is
    l_keyword         file_meta_data.keyword%type not null:=i_keyword ;
    l_filename_match  file_meta_data.filename_match%type not null:=i_filename_match;
    l_fad_id          file_meta_data.fad_id%type not null:=i_fad_id;
    l_character_set   file_meta_data.character_set%type not null:=i_character_set;
  begin
    insert into file_meta_data (
      fmd_id,
      keyword,
      filename_match,
      fad_id,
      character_set,
      delimiter,
      enclosure
    ) values (
      file_meta_data_seq.nextval,
      l_keyword,
      l_filename_match,
      l_fad_id,
      l_character_set,
      i_delimiter,
      i_enclosure
    );
    commit;
  end insert_row;
--------------------------------------------------------------------------------
  procedure update_file_meta_data (
    i_fmd_id          in file_meta_data.fmd_id%type,
    i_keyword         in file_meta_data.keyword%type,
    i_filename_match  in file_meta_data.filename_match%type,
    i_fad_id          in file_meta_data.fad_id%type,
    i_character_set   in file_meta_data.character_set%type,
    i_delimiter       in file_meta_data.delimiter%type,
    i_enclosure       in file_meta_data.enclosure%type)
  is
    -- TODO validation bei notnull!
  begin
    null;
  end update_file_meta_data;
--------------------------------------------------------------------------------
end file_meta_data_api;
/