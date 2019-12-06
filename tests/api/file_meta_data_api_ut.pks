create or replace package file_meta_data_api_ut authid definer as

  -- %suite(UnitTests for API package FILE_META_DATA_API)

  -- %test(Insert a new row into table.)
  procedure insert_row_example;

  -- %test(Update an existing row from table.)
  procedure update_row_example;

  -- %test(Delete a row from the table.)
  procedure delete_row_example;

end file_meta_data_api_ut;
/
