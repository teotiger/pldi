create or replace package file_text_data_api_ut authid definer as

  -- %suite(UnitTests for API package FILE_TEXT_DATA_API)

  -- %test(Insert new rows into table.)
  procedure insert_rows_example;

  -- %test(Insert new rows into table without metadata should fail.)
  -- %throws(-1403)
  procedure insert_rows_fails_example;

  -- %test(Delete rows from the table.)
  procedure delete_rows_example;

end file_text_data_api_ut;
/
