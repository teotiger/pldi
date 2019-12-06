create or replace package file_meta_data_api authid definer 
as

  -- Add a new row to FILE_META_DATA and returns the corresponding FMD_ID.
  function insert_row (
      i_fad_id                        in number,
      i_filename_match_filter         in varchar2,
      i_filter_is_regular_expression  in number,
      i_ora_charset_name              in varchar2,
      i_delimiter                     in varchar2,
      i_enclosure                     in varchar2,
      i_plsql_after_processing        in varchar2,
      i_keyword                       in varchar2,
      i_description_text              in varchar2)
    return number;

  -- Add a new row to FILE_META_DATA.
  procedure insert_row (
    i_fad_id                        in number,
    i_filename_match_filter         in varchar2,
    i_filter_is_regular_expression  in number,
    i_ora_charset_name              in varchar2,
    i_delimiter                     in varchar2,
    i_enclosure                     in varchar2,
    i_plsql_after_processing        in varchar2,
    i_keyword                       in varchar2,
    i_description_text              in varchar2);

  -- Update an existing row in FILE_META_DATA.
  procedure update_row (
    i_fmd_id              in number,
    i_fmd_id_is_inactive  in number);

  -- Remove an existing row from FILE_META_DATA.
  procedure delete_row (i_fmd_id in number);

end file_meta_data_api;
/