create or replace package file_status_data_api authid definer 
as

  -- Add a new row to FILE_STATUS_DATA.
  procedure insert_row (
    i_frd_id        in file_raw_data.frd_id%type,
    i_filename      in file_raw_data.filename%type,
    i_filesize      in file_raw_data.filesize%type,
    i_seconds_step1 in file_status_data.seconds_step1%type);

  -- Modify an existing row in FILE_STATUS_DATA.
  procedure update_row (
    i_fsd_id        in file_status_data.fsd_id%type,
    i_fmd_id        in file_meta_data.fmd_id%type,
    i_fad_id        in file_adapter_data.fad_id%type,
    i_ftd_id        in file_text_data.ftd_id%type,
    i_seconds_step2 in file_status_data.seconds_step2%type);

  -- Modify an existing row in FILE_STATUS_DATA.
  procedure update_row (
    i_fsd_id        in file_status_data.fsd_id%type,
    i_seconds_step3 in file_status_data.seconds_step3%type);

  -- Modify an existing row in FILE_STATUS_DATA.
  procedure update_row (
    i_fsd_id        in file_status_data.fsd_id%type,
    i_error_message in file_status_data.error_message%type);

  -- Remove a row from FILE_STATUS_DATA.
  procedure delete_row (
    i_fsd_id in file_status_data.fsd_id%type);

end file_status_data_api;
/