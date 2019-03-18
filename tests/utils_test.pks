create or replace package utils_test authid definer as

  -- %suite(UnitTests for di_util package)

  -- %test(Non-existent directory)
  -- %throws(-22285)
  procedure insert_file_non_existing_dir;

  -- %test(No such file)
  -- %throws(-22288)
  procedure insert_file_non_existing_file;  

end utils_test;
/
