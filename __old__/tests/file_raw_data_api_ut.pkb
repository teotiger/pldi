create or replace package body file_raw_data_api_ut as
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_dir is
  begin
    file_raw_data_api.insert_row('samplefile.txt', '$?#*~');
  end insert_file_non_existing_dir;
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_file is
  begin
    file_raw_data_api.insert_row('$?#*~');
  end insert_file_non_existing_file;
--------------------------------------------------------------------------------
end file_raw_data_api_ut;
/
