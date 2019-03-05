create or replace package di.file_adapter_data_imp_2 authid definer 
as

  -- This procedure try to extract the binary data to structured tabular data.
  -- @The file-raw-data-ID (primary key from FILE_RAW_DATA table).
  -- @The file-meta-data-ID (primary key from FILE_META_DATA table).
  -- @The character set to encode the file.
  procedure insert_file_text_data(
    i_frd_id        in file_raw_data.frd_id%type,
    i_fmd_id        in file_meta_data.fmd_id%type,
    i_character_set in file_meta_data.character_set%type);

end file_adapter_data_imp_2;
/