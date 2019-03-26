create or replace package body file_meta_data_api
as
--------------------------------------------------------------------------------
  procedure insert_row (
    i_keyword                     in file_meta_data.keyword%type,
    i_filename_match_like         in file_meta_data.filename_match_like%type,
    i_filename_match_regexp_like  in file_meta_data.filename_match_regexp_like%type,
    i_fad_id                      in file_meta_data.fad_id%type,
    i_character_set               in file_meta_data.character_set%type,
    i_delimiter                   in file_meta_data.delimiter%type,
    i_enclosure                   in file_meta_data.enclosure%type,
    i_plsql_after_processing      in file_meta_data.plsql_after_processing%type)
  is
    l_keyword               file_meta_data.keyword%type not null:=i_keyword ;
    l_filename_match_like   file_meta_data.filename_match_like%type not null:=i_filename_match_like;
    l_fad_id                file_meta_data.fad_id%type not null:=i_fad_id;
    l_character_set         file_meta_data.character_set%type not null:=i_character_set;
  begin
    insert into file_meta_data (
      fmd_id,
      keyword,
      filename_match_like,
      filename_match_regexp_like,
      fad_id,
      character_set,
      delimiter,
      enclosure,
      plsql_after_processing
    ) values (
      file_meta_data_seq.nextval,
      l_keyword,
      l_filename_match_like,
      i_filename_match_regexp_like,
      l_fad_id,
      l_character_set,
      i_delimiter,
      i_enclosure,
      i_plsql_after_processing
    );
    commit;
  end insert_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fmd_id                      in file_meta_data.fmd_id%type,
    i_keyword                     in file_meta_data.keyword%type,
    i_filename_match_like         in file_meta_data.filename_match_like%type,
    i_filename_match_regexp_like  in file_meta_data.filename_match_regexp_like%type,
    i_fad_id                      in file_meta_data.fad_id%type,
    i_character_set               in file_meta_data.character_set%type,
    i_delimiter                   in file_meta_data.delimiter%type,
    i_enclosure                   in file_meta_data.enclosure%type,
    i_plsql_after_processing      in file_meta_data.plsql_after_processing%type)
  is
    l_fmd_id file_meta_data.fmd_id%type not null:=i_fmd_id;
  begin
    update file_meta_data
       set keyword=nvl(i_keyword,keyword),
           filename_match_like=nvl(i_filename_match_like,filename_match_like),
           filename_match_regexp_like=nvl(i_filename_match_regexp_like,filename_match_regexp_like),
           fad_id=nvl(i_fad_id,fad_id),
           character_set=nvl(i_character_set,character_set),
           delimiter=nvl(i_delimiter,delimiter),
           enclosure=nvl(i_enclosure,enclosure),
           plsql_after_processing=nvl(i_plsql_after_processing,plsql_after_processing)
     where fmd_id=l_fmd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure delete_row (
    i_fmd_id  in file_meta_data.fmd_id%type)
  is
    l_fmd_id file_meta_data.fmd_id%type not null:=i_fmd_id;
  begin
    delete file_meta_data 
     where fmd_id=l_fmd_id;
    commit;
  end delete_row;  
--------------------------------------------------------------------------------
end file_meta_data_api;
/