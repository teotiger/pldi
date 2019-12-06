create or replace package file_raw_data_api authid definer 
as

  -- Add a new row to FILE_RAW_DATA and returns the corresponding FRD_ID.
  function insert_row (
      i_filename    in varchar2,
      i_blob_value  in blob)
    return number;

  -- Add a new row to FILE_RAW_DATA.
  procedure insert_row (
    i_filename    in varchar2,
    i_blob_value  in blob);

  -- Add a new row to FILE_RAW_DATA and returns the corresponding FRD_ID.
  function insert_row (
      i_filename  in varchar2,
      i_directory in varchar2 default utils.directory_setting)
    return number;

  -- Add a new row to FILE_RAW_DATA.
  procedure insert_row (
    i_filename  in varchar2,
    i_directory in varchar2 default utils.directory_setting);

  -- Remove an existing row from FILE_RAW_DATA.
  procedure delete_row (i_frd_id in number);

  -- Housekeeping for FILE_RAW_DATA depending on configuration.
  -- Return the number of deleted rows.
  function housekeeping(i_frd_id in number) return number;

end file_raw_data_api;
/