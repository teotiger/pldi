create or replace package file_adapter_data_api authid definer 
as

  -- Add a new row to FILE_ADAPTER_DATA.
  procedure insert_row (
    i_description_text in file_adapter_data.description_text%type);

  -- Modify an existing row in FILE_ADAPTER_DATA.
  procedure update_row (
    i_fad_id in file_adapter_data.fad_id%type,
    i_description_text in file_adapter_data.description_text%type);

  -- Remove a row from FILE_ADAPTER_DATA.
  procedure delete_row (
    i_fad_id in file_adapter_data.fad_id%type);

end file_adapter_data_api;
/