create or replace package file_text_data_api authid definer 
as

  -- Add new rows to FILE_TEXT_DATA.
  procedure insert_rows (
    i_filename  in file_raw_data.filename%type);
    
  -- Add new rows to FILE_TEXT_DATA and returns the PLSQL code to execute after.
  function insert_rows (
      i_frd_id  in file_raw_data.frd_id%type)
    return varchar2;
    
end file_text_data_api;
/