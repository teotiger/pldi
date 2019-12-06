create or replace package utils authid definer 
as

  -- This function returns the current version.
  function version return varchar2 deterministic;

  -- This function returns the default directory.
  function default_directory 
    return varchar2 deterministic;
  
  -- This function converts the binary large object to a character large object.
  -- @The value of the BLOB.
  -- @The Oracle character set ID number corresponding to character set name.
  function blob_to_clob (
      i_blob_value     in blob,
      i_ora_charset_id in number)
    return clob deterministic;
  
  -- This function converts the character large object to a binary large object.
  -- @The value of the CLOB.
  -- @The Oracle character set ID number corresponding to character set name.
  function clob_to_blob (
      i_clob_value     in clob,
      i_ora_charset_id in number)
    return blob deterministic;

  -- Split the argument into several parts.
  -- @The input string.
  -- @The delimiter (one character only).
  -- @The field enclosure character (one character only).
  -- @Remove the enclosure from result (true) or not (false)
  function split_varchar2 (
      i_string_value    in varchar2,
      i_delimiter       in varchar2,
      i_enclosure       in varchar2,
      i_trim_enclosure  in boolean default true)
    return sys.ora_mining_varchar2_nt deterministic;

  -- This function formats the number of seconds.
  -- @The number of seconds.
  function format_seconds(
      a_seconds in number)
    return varchar2 deterministic;

  -- This function tries to extract the content of a given ID from FILE_RAW_DATA
  -- and return the corresponding ID from FILE_TEXT_DATA.
  -- @The ID from FILE_RAW_DATA.
  function processing_from_raw (
      i_frd_id in number)
    return number;

  -- This procedure use a given ID from FILE_TEXT_DATA and finally execute some
  -- PLSQL code if it is configured in FILE_META_DATA.
  -- @The ID from FILE_TEXT_DATA.
  procedure processing_from_text (
      i_ftd_id in number);

  -- This procedure insert a file into FILE_RAW_DATA and then tries to extract
  -- the content to FILE_TEXT_DATA. Finally it execute some PLSQL code if it is
  -- configured in FILE_META_DATA.
  -- @The name of the file.
  procedure processing_file (
      i_filename in varchar2);

end utils;
/