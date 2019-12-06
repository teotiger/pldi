create or replace package body file_meta_data_api
as
--------------------------------------------------------------------------------
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
    return number
  is
    l_fmd_id file_meta_data.fmd_id%type not null:=file_meta_data_seq.nextval;
  begin
    insert into file_meta_data (
      fmd_id,
      fad_id,
      filename_match_filter,
      filter_is_regular_expression,
      ora_charset_name,
      delimiter,
      enclosure,
      plsql_after_processing,
      keyword,
      description_text,
      username_insert,
      username_update
    ) values (
      l_fmd_id,
      i_fad_id,
      i_filename_match_filter,
      i_filter_is_regular_expression,
      i_ora_charset_name,
      i_delimiter,
      i_enclosure,
      i_plsql_after_processing,
      i_keyword,
      i_description_text,
      utils.username,
      utils.username
    );
    return l_fmd_id;  
  end insert_row;
--------------------------------------------------------------------------------
  procedure insert_row (
    i_fad_id                        in number,
    i_filename_match_filter         in varchar2,
    i_filter_is_regular_expression  in number,
    i_ora_charset_name              in varchar2,
    i_delimiter                     in varchar2,
    i_enclosure                     in varchar2,
    i_plsql_after_processing        in varchar2,
    i_keyword                       in varchar2,
    i_description_text              in varchar2)
  is
    l_fmd_id file_meta_data.fmd_id%type;
  begin
    l_fmd_id:=insert_row(i_fad_id => i_fad_id,
                         i_filename_match_filter => i_filename_match_filter,
                         i_filter_is_regular_expression => i_filter_is_regular_expression,
                         i_ora_charset_name => i_ora_charset_name,
                         i_delimiter => i_delimiter,
                         i_enclosure => i_enclosure,
                         i_plsql_after_processing => i_plsql_after_processing,
                         i_keyword => i_keyword,
                         i_description_text => i_description_text);
  end insert_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fmd_id              in number,
    i_fmd_id_is_inactive  in number)
  is
    l_fmd_id file_meta_data.fmd_id%type not null:=i_fmd_id;
    l_fmd_id_is_inactive file_meta_data.fmd_id_is_inactive%type not null:=i_fmd_id_is_inactive;
  begin
    update file_meta_data
       set fmd_id_is_inactive=l_fmd_id_is_inactive
     where fmd_id=l_fmd_id;
  end update_row;
--------------------------------------------------------------------------------
  procedure delete_row (i_fmd_id in number)
  is
    l_fmd_id file_meta_data.fmd_id%type not null:=i_fmd_id;
  begin
    delete from file_meta_data where fmd_id=l_fmd_id;
  end delete_row;
--------------------------------------------------------------------------------
end file_meta_data_api;
/