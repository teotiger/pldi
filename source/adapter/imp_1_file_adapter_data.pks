create or replace package imp_1_file_adapter_data authid definer 
as

  -- This procedure try to extract the binary data to structured tabular data.
  -- @The file-raw-data-ID (primary key from FILE_RAW_DATA table).
  -- @The file-meta-data-ID (primary key from FILE_META_DATA table).
  -- @The file-text-data-ID from FILE_TEXT_DATA table.
  -- @The binary large object.
  -- @The Oracle character set id to encode the file.
  -- @The Oracle character set name to encode the file.
  procedure insert_file_text_data(
    i_frd_id            in number,
    i_fmd_id            in number,
    i_ftd_id            in number,
    i_blob_value        in blob,
    i_ora_charset_id    in number,
    i_ora_charset_name  in varchar2
  );



  -- Convert BLOB to CLOB with corresponding charset and normalize the line
  -- endings to unix mode (LF).
  function blob_to_unix_clob(
      i_blob_value      in blob,
      i_ora_charset_id  in pls_integer)
    return clob deterministic;

  -- Split a string into an array of strings.
  function split_vc2(
      i_string_value    in varchar2,
      i_delimiter       in varchar2,
      i_enclosure       in varchar2,
      i_trim_enclosure  in boolean default true)
    return sys.ora_mining_varchar2_nt deterministic;

end imp_1_file_adapter_data;
/