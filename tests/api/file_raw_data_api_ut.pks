create or replace package file_raw_data_api_ut authid definer as

  -- %suite(UnitTests for API package FILE_RAW_DATA_API)

  -- %test(Insert some characters as BLOB into table.)
  procedure insert_row_from_string;

  -- %test(Insert from a non-existent directory.)
  -- %throws(-22285)
  procedure insert_file_non_existing_dir;

  -- %test(Insert a non-existent file.)
  -- %throws(-22288)
  procedure insert_file_non_existing_file;  

  -- %test(Delete a row from the table.)
  procedure delete_row;

end file_raw_data_api_ut;
/
