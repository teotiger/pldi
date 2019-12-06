create or replace package file_status_data_api_ut authid definer as

  -- %suite(UnitTests for API package FILE_STATUS_DATA_API)

  -- %test(Insert a new row into table.)
  procedure insert_row_with_filename;

  -- %test(Update an existing row with information from processing step 1.)
  procedure update_row_with_info_1;

  -- %test(Update an existing row with information from processing step 2.)
  procedure update_row_with_info_2;

  -- %test(Update an existing row with information from processing step 3.)
  procedure update_row_with_info_3;

  -- %test(Update an existing row with information from processing step 4.)
  procedure update_row_with_info_4;

  -- %test(Update an existing row with an error message text.)
  procedure update_row_with_error_message;

  -- %test(Delete a row from the table.)
  procedure delete_row;


  -- %afterall
  procedure global_cleanup;

end file_status_data_api_ut;
/
