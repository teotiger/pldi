create or replace package file_meta_data_api_ut authid definer as

  -- %suite(UnitTests for PLDI package FILE_META_DATA_API)
  -- %rollback(manual)

  -- %beforeall
  procedure setup;
  
  -- %afterall
  procedure teardown;

  -- %test(Update a single field)
  procedure update_row_single;

  -- %test(Update several fields.)
  procedure update_row_multi;

  -- %test(Try to delete a row with dependent data in FILE_TEXT_DATA.)
  -- %throws(-2292)
  procedure delete_row_default;

  -- %test(Delete a row with dependent data in FILE_TEXT_DATA.)
  procedure delete_row_force;

end file_meta_data_api_ut;
/
