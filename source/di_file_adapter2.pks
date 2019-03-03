create or replace package di.di_file_adapter2 authid definer 
as

  -- This procedure try to extract the binary data to structured tabular data.
  -- @The file-raw-data-ID (primary key from FILE_RAW_DATA table).
  -- @The row content from FILE_META_DATA table.
  procedure insert_file_text_data(
    i_frd_id  in file_raw_data.frd_id%type,
    i_fmd_row in file_meta_data%rowtype);

end di_file_adapter2;
/