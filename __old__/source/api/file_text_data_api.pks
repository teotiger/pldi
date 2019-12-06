create or replace package file_text_data_api authid definer 
as

  -- Add new rows to FILE_TEXT_DATA.
  procedure insert_rows (
    i_frd_id  in file_raw_data.frd_id%type);
    
  -- Add new rows to FILE_TEXT_DATA and returns the corresponding FTD_ID.
  function insert_rows (
      i_frd_id  in file_raw_data.frd_id%type)
    return number;

  -- Add new rows to FILE_TEXT_DATA.
  procedure insert_rows (
      i_frd_id    in  file_raw_data.frd_id%type,
      o_ftd_id    out file_text_data.ftd_id%type,
      o_fmd_id    out file_meta_data.fmd_id%type,
      o_fad_id    out file_adapter_data.fad_id%type,
      o_filename  out nocopy file_raw_data.filename%type,
      o_filesize  out nocopy file_raw_data.filename%type);

  -- Remove rows from FILE_TEXT_DATA.
  procedure delete_rows (
    i_ftd_id in file_text_data.ftd_id%type);
    
end file_text_data_api;
/