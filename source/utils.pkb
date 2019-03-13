create or replace package body utils
as
--------------------------------------------------------------------------------
  function default_directory 
    return varchar2 deterministic
  is
    c_dir constant varchar2(30 char):='&&pldi_directory.';
  begin
    return c_dir;
  end default_directory;
--------------------------------------------------------------------------------
  function blob_to_clob (
      i_blob_value in blob,
      i_charset_id in number)
    return clob
  is
    l_blob_value blob not null:=i_blob_value;
    l_charset_id number not null:=i_charset_id;
    l_clob clob;
    l_dest_offset integer := 1;
    l_src_offset integer := 1;
    l_lang_context integer := dbms_lob.default_lang_ctx;
    l_warning  integer;
  begin
    dbms_lob.createtemporary(
      lob_loc => l_clob,
      cache => true);
    dbms_lob.converttoclob(
      dest_lob => l_clob, 
      src_blob => l_blob_value,
      amount => dbms_lob.lobmaxsize,
      dest_offset => l_dest_offset,
      src_offset => l_src_offset,
      blob_csid => l_charset_id,
      lang_context => l_lang_context,
      warning => l_warning);
    return l_clob;
  end blob_to_clob;  
--------------------------------------------------------------------------------
  function clob_to_blob (
      i_clob_value in clob,
      i_charset_id in number)
    return blob 
  is
    l_clob_value clob not null:=i_clob_value;
    l_charset_id number not null:=i_charset_id;
    l_blob blob; 
    l_dest_offset integer := 1;
    l_src_offset integer := 1;
    l_lang_context integer := dbms_lob.default_lang_ctx;
    l_warning  integer;
  begin
    dbms_lob.createtemporary(
      lob_loc => l_blob,
      cache => true); 
    dbms_lob.converttoblob(
      dest_lob => l_blob,
      src_clob => l_clob_value,
      amount => length(l_clob_value),
      dest_offset => l_dest_offset,
      src_offset => l_src_offset,
      blob_csid => l_charset_id,
      lang_context => l_lang_context,
      warning => l_warning);
    return l_blob;
  end clob_to_blob;
--------------------------------------------------------------------------------
  procedure processing_file (
      i_filename in varchar2)
  is
    l_sql varchar2(4000 char);
  begin
    l_sql:=file_text_data_api.insert_rows(
            i_frd_id => file_raw_data_api.insert_row(i_filename)
           );
    if l_sql is not null then
      execute immediate l_sql;
    end if;
  end processing_file;
--------------------------------------------------------------------------------
end utils;
/