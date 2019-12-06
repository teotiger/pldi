create or replace package body file_adapter_data_api
as
--------------------------------------------------------------------------------
  function insert_row (
      i_keyword           in varchar2,
      i_description_text  in varchar2)
    return number
  is
    l_keyword file_adapter_data.keyword%type not null:=i_keyword;
    l_description_text file_adapter_data.description_text%type:=i_description_text;
    l_fad_id file_adapter_data.fad_id%type not null:=file_adapter_data_seq.nextval;
  begin
    insert into file_adapter_data (
      fad_id,
      keyword,
      description_text,
      username_insert,
      username_update
    ) values (
      l_fad_id,
      l_keyword,
      l_description_text,
      utils.username,
      utils.username
    );
    return l_fad_id;  
  end insert_row;
--------------------------------------------------------------------------------
  procedure insert_row (
    i_keyword           in varchar2,
    i_description_text  in varchar2)
  is
    l_keyword file_adapter_data.keyword%type not null:=i_keyword;
    l_description_text file_adapter_data.description_text%type:=i_description_text;
    l_fad_id file_adapter_data.fad_id%type;
  begin
    l_fad_id:=insert_row(i_keyword => l_keyword,
                         i_description_text => l_description_text);
  end insert_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fad_id            in number,
    i_keyword           in varchar2,
    i_description_text  in varchar2)
  is
    l_fad_id file_adapter_data.fad_id%type not null:=i_fad_id;
    l_keyword file_adapter_data.keyword%type not null:=i_keyword;
    l_description_text file_adapter_data.description_text%type:=i_description_text;
  begin
    update file_adapter_data
       set keyword=l_keyword,
           description_text=l_description_text
     where fad_id=l_fad_id;
  end update_row;
--------------------------------------------------------------------------------
  procedure delete_row (i_fad_id in number)
  is
    l_fad_id file_adapter_data.fad_id%type not null:=i_fad_id;
  begin
    delete from file_adapter_data where fad_id=l_fad_id;
  end delete_row;
--------------------------------------------------------------------------------
end file_adapter_data_api;
/