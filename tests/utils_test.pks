create or replace package utils_test authid definer as

  -- %suite(UnitTests for PLDI)
  --%rollback(manual)
  
  -- %beforeall
  procedure setup;

  -- %afterall
  procedure teardown;
  
  -- %test(Non-existent directory)
  -- %throws(-22285)
  procedure insert_file_non_existing_dir;

  -- %test(No such file)
  -- %throws(-22288)
  procedure insert_file_non_existing_file;  

  -- %test(Check complete import from csv files with variable columns)
  procedure imp_1_adapter_csv_w_var_cols;  

end utils_test;
/
