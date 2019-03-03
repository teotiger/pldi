create or replace package di.di_util authid definer 
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
  function blob_to_clob (
      i_blob_value in blob)
    return clob;

  ----------------------------------------------------------------------------

  -- This function insert the file as a blob in FILE_RAW_DATA.
  -- @The filename.
  -- @The directory.
  function insert_file_raw_data (
      i_filename  in varchar2,
      i_directory in varchar2 default default_directory)
    return error_code deterministic;
  
  -- insert...
  procedure insert_file_meta_data (
    i_keyword               in file_meta_data.keyword%type,
    i_filename_match        in file_meta_data.filename_match%type,
    i_fad_id                in file_meta_data.fad_id%type,
    i_character_encoding    in file_meta_data.character_encoding%type,
    i_delimiter             in file_meta_data.delimiter%type,
    i_enclosure             in file_meta_data.enclosure%type);
  
  -- update...
  procedure update_file_meta_data (
    i_fmd_id               in file_meta_data.fmd_id%type,
    i_keyword              in file_meta_data.keyword%type,
    i_filename_match       in file_meta_data.filename_match%type,
    i_fad_id               in file_meta_data.fad_id%type,
    i_character_encoding   in file_meta_data.character_encoding%type,
    i_delimiter            in file_meta_data.delimiter%type,
    i_enclosure            in file_meta_data.enclosure%type);

end di_util;
/