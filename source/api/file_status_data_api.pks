create or replace package file_status_data_api authid definer 
as

  -- Add a new row to FILE_STATUS_DATA and returns the corresponding FSD_ID.
  function insert_row (i_filename in varchar2) return number;

  -- Add a new row to FILE_STATUS_DATA.
  procedure insert_row (i_filename in varchar2);

  -- Update an existing row with seconds needed to process step 1.
  procedure update_row (
    i_fsd_id    in number,
    i_frd_id    in number,
    i_seconds_1 in number);

  -- Update an existing row with seconds needed to process step 2.
  procedure update_row (
    i_fsd_id    in number,
    i_ftd_id    in number,
    i_fmd_id    in number,
    i_fad_id    in number,
    i_seconds_2 in number);

  -- Update an existing row with seconds needed to process step 3.
  procedure update_row (
    i_fsd_id    in number,
    i_frd_id    in number,
    i_seconds_3 in number);

  -- Update an existing row with seconds needed to process step 4.
  procedure update_row (
    i_fsd_id    in number,
    i_frd_id    in number,
    i_seconds_4 in number);

  -- Update an existing row with an error message.
  procedure update_row (
    i_fsd_id        in number,
    i_error_message in varchar2);

  -- Remove an existing row from FILE_STATUS_DATA.
  procedure delete_row (i_fsd_id in number);

  -- Remove any row from FILE_STATUS_DATA where the filename match.
  procedure delete_rows (i_filename in varchar2);

end file_status_data_api;
/