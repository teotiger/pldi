create or replace package file_adapter_data_imp_1 authid definer 
as

  -- This procedure try to extract the binary data to structured tabular data.
  -- @The file-raw-data-ID (primary key from FILE_RAW_DATA table).
  -- @The binary large object.
  -- @The file-meta-data-ID (primary key from FILE_META_DATA table).
  -- @The character set to encode the file.
  -- @The file-text-data-ID from FILE_TEXT_DATA table.
  procedure insert_file_text_data(
    i_frd_id      in file_raw_data.frd_id%type,
    i_blob        in file_raw_data.blob_value%type,
    i_fmd_id      in file_meta_data.fmd_id%type,
    i_charset_id  in file_meta_data.ora_charset_id%type,
    i_ftd_id      in file_text_data.ftd_id%type);

end file_adapter_data_imp_1;
/