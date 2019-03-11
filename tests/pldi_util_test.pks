create or replace package &&pldi_user..pldi_util_test authid definer as

  -- %suite(UnitTests for di_util package)

  -- %test(Error Code 1 - Non-existent directory)
  procedure insert_file_non_existing_dir;

  -- %test(Error Code 2 - No such file)
  procedure insert_file_non_existing_file;  

end pldi_util_test;
/
