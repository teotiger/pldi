create or replace package utils authid definer 
as

  -- This function returns the default directory.
  function version return varchar2 deterministic;

  -- This function returns the default directory.
  function default_directory 
    return varchar2 deterministic;
  
  -- This function converts the binary large object to a character large object.
  -- @The value of the BLOB.
  -- @The (Oracle) character set ID number corresponding to character set name.
  function blob_to_clob (
      i_blob_value in blob,
      i_charset_id in number)
    return clob deterministic;
  
  -- This function converts the character large object to a binary large object.
  -- @The value of the CLOB.
  -- @The (Oracle) character set ID number corresponding to character set name.
  function clob_to_blob (
      i_clob_value in clob,
      i_charset_id in number)
    return blob deterministic;

  -- Split the argument into several parts.
  -- @The input string.
  -- @The delimiter (one character only).
  -- @The field enclosure character (one character only).
  function split_varchar2 (
      i_string_value in varchar2,
      i_delimiter    in varchar2,
      i_enclosure    in varchar2)
    return sys.ora_mining_varchar2_nt deterministic;
    
  -- This procedure insert a file into FILE_RAW_DATA and then tries to extract
  -- the content to FILE_TEXT_DATA.
  -- @The name of the file.
  procedure processing_file (
      i_filename in varchar2);
      
end utils;
/