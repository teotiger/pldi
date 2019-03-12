create or replace package file_text_data_api authid definer 
as

  -- Add new rows to FILE_TEXT_DATA.
  procedure insert_rows (
    i_filename  in file_raw_data.filename%type);
    
end file_text_data_api;
/