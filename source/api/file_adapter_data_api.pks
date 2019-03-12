create or replace package file_adapter_data_api authid definer 
as

  -- Add a new row to FILE_ADAPTER_DATA.
  procedure insert_row (
    i_description_text in file_adapter_data.description_text%type);

  -- Modify an existing row in FILE_ADAPTER_DATA.
  procedure update_row;                                                         -- TODO

  -- Remove a row from FILE_ADAPTER_DATA.
  procedure delete_row;                                                         -- TODO

end file_adapter_data_api;
/