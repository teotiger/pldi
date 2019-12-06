create or replace package file_raw_data_api_ut authid definer as

  -- %suite(UnitTests for PLDI package FILE_RAW_DATA_API)
  
  -- %test(Non-existent directory)
  -- %throws(-22285)
  procedure insert_file_non_existing_dir;

  -- %test(No such file)
  -- %throws(-22288)
  procedure insert_file_non_existing_file;  

end file_raw_data_api_ut;
/
