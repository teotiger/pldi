create or replace package file_text_data_api authid definer 
as

  -- Add new rows to FILE_TEXT_DATA.
  procedure insert_rows (
    i_frd_id  in file_raw_data.frd_id%type);
    
  -- Add new rows to FILE_TEXT_DATA and returns the corresponding FTD_ID.
  function insert_rows (
      i_frd_id  in file_raw_data.frd_id%type)
    return number;

  -- Remove rows from FILE_TEXT_DATA.
  procedure delete_rows (
    i_ftd_id in file_text_data.ftd_id%type);
    
end file_text_data_api;
/