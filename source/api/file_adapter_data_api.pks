create or replace package file_adapter_data_api authid definer 
as

  -- Add a new row to FILE_ADAPTER_DATA and returns the corresponding FAD_ID.
  function insert_row (
      i_keyword           in varchar2,
      i_description_text  in varchar2)
    return number;

  -- Add a new row to FILE_ADAPTER_DATA.
  procedure insert_row (
    i_keyword           in varchar2,
    i_description_text  in varchar2);

  -- Update an existing row in FILE_ADAPTER_DATA.
  procedure update_row (
    i_fad_id            in number,
    i_keyword           in varchar2,
    i_description_text  in varchar2);

  -- Remove an existing row from FILE_ADAPTER_DATA.
  procedure delete_row (i_fad_id in number);

end file_adapter_data_api;
/