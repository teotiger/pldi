create or replace package &&pldi_user..file_adapter_data_api authid definer 
as

  -- insert...
  procedure insert_row (
    i_description_text in file_adapter_data.description_text%type);

end file_adapter_data_api;
/