create or replace package body file_raw_data_api
as
--------------------------------------------------------------------------------
--> https://oracle-base.com/articles/8i/import-blob
--------------------------------------------------------------------------------
  procedure insert_row (
    i_filename  in file_raw_data.filename%type,
    i_directory in varchar2)
  is
    l_frd_id file_raw_data.frd_id%type;
  begin
    l_frd_id:=insert_row(i_filename, i_directory);
  end insert_row;
--------------------------------------------------------------------------------
  function insert_row (
      i_filename  in file_raw_data.filename%type,
      i_directory in varchar2)
    return number
  is
    l_filename file_raw_data.filename%type not null := i_filename;
    l_directory varchar2(30 char) := i_directory;
    l_frd_id file_raw_data.frd_id%type;
    l_bfile bfile;
    l_blob blob;
    l_dest_offset integer := 1;
    l_src_offset integer := 1;
  begin
    l_frd_id:=file_raw_data_seq.nextval;
    insert into file_raw_data (
      frd_id,
      timestamp_insert,
      filename,
      blob_value
    ) values (
      l_frd_id,
      systimestamp,
      l_filename,
      empty_blob()
    ) return blob_value into l_blob;

    l_bfile := bfilename(l_directory, l_filename);
      
    dbms_lob.fileopen(l_bfile, dbms_lob.file_readonly);
    if dbms_lob.getlength(l_bfile) > 0 then
      sys.dbms_lob.loadblobfromfile(
        dest_lob => l_blob,
        src_bfile => l_bfile,
        amount => sys.dbms_lob.lobmaxsize, 
        dest_offset => l_dest_offset,
        src_offset => l_src_offset
      );
    end if;
    dbms_lob.fileclose(l_bfile);
    commit;
    
    return l_frd_id;
  end insert_row;
--------------------------------------------------------------------------------
  procedure insert_row (
    i_filename      in file_raw_data.filename%type,
    i_plain_text    in clob,
    i_character_set in file_meta_data.character_set%type)
  is
    l_frd_id file_raw_data.frd_id%type;
  begin
    l_frd_id:=insert_row (i_filename, i_plain_text, i_character_set);
  end;
--------------------------------------------------------------------------------
  function insert_row (
      i_filename      in file_raw_data.filename%type,
      i_plain_text    in clob,
      i_character_set in file_meta_data.character_set%type)
    return number
  is
    l_filename file_raw_data.filename%type not null := i_filename;
    l_plain_text clob not null:=i_plain_text;
    l_character_set file_meta_data.character_set%type not null := i_character_set;
    l_ora_charset_id integer not null:=nls_charset_id(replace(l_character_set,'-',''));
    l_blob blob;    
    l_frd_id file_raw_data.frd_id%type;    
  begin
    l_blob:=utils.clob_to_blob(
      i_clob_value => l_plain_text,
      i_charset_id => l_ora_charset_id);
    l_frd_id:=file_raw_data_seq.nextval;
    insert into file_raw_data (
      frd_id,
      timestamp_insert,
      filename,
      blob_value
    ) values (
      l_frd_id,
      systimestamp,
      l_filename,
      l_blob
    );
    commit;
    
    return l_frd_id;
  end;
--------------------------------------------------------------------------------
end file_raw_data_api;
/