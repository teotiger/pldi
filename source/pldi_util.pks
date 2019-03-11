create or replace package &&pldi_user..pldi_util authid definer 
as

  subtype error_code is binary_integer range 0..9;
  
  ----------------------------------------------------------------------------

  -- This function returns the corresponding error message to an error code.
  -- @The error code.
  function error_code_to_error_message (
      i_error_code in error_code) 
    return varchar2 deterministic;
  -- This function returns the default directory.
  function default_directory 
    return varchar2 deterministic;
  -- This function converts the binary large object to a character large object.
  -- @The value of the BLOB.
  -- @The (Oracle) character set ID number corresponding to character set name.
  function blob_to_clob (
      i_blob_value in blob,
      i_charset_id in number)
    return clob;

  ----------------------------------------------------------------------------

  -- This function insert the file as a blob in FILE_RAW_DATA.
  -- @The filename.
  -- @The directory.
  function insert_file_raw_data (
      i_filename  in varchar2,
      i_directory in varchar2 default default_directory)
    return error_code deterministic;

end pldi_util;
/