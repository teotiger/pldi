create or replace package body di.di_util
as
--------------------------------------------------------------------------------
  function error_code_to_error_message (
      i_error_code in error_code)
    return varchar2 deterministic
  is
  begin
    return case i_error_code
            when 1 then 'Non-existent directory'
            when 2 then 'No such file'
           end;
  end error_code_to_error_message;
--------------------------------------------------------------------------------
  function default_directory 
    return varchar2 deterministic
  is
    c_dir constant varchar2(30 char):='DI_DIR';
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
    blob_csid => l_charset_id,--dbms_lob.default_csid,
    lang_context => l_lang_context,
    warning => l_warning);
  return l_clob;
end blob_to_clob;  
--------------------------------------------------------------------------------
--> https://oracle-base.com/articles/8i/import-blob
--------------------------------------------------------------------------------
  function insert_file_raw_data (
      i_filename  in varchar2,
      i_directory in varchar2 default default_directory)
    return error_code deterministic
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
     
--di_file_adapter'||l_fmd_row.fad_id||'.insert_file_text_data(:0, :1, :2); end;';

 dbms_output.put_line('bef');     
di_file_adapter1.insert_file_text_data(l_frd_id, l_blob, 5, 'UTF-8'); 
 dbms_output.put_line('aft');     

--i_frd_id        in file_raw_data.frd_id%type,
--    i_blob        in file_raw_data.blob_value%type,
--    i_fmd_id        in file_meta_data.fmd_id%type,
--    i_ch
--  execute immediate l_sql using :new.frd_id, :new.blob_value,l_fmd_row.fmd_id, l_fmd_row.character_set;     
     
    commit;
    return 0;
  
  exception 
    when others then
      rollback;
      case sqlcode
        when -22285 then --Non-existent directory or file for FILEOPEN operation
          return 1;
        when -22288 then --No such file or directory
          return 2;
        else
          -- TODO
--          sys.dbms_output.put_line(sqlerrm); 
--          return sqlcode;
          
          raise;
          
      end case;
  end insert_file_raw_data;
--------------------------------------------------------------------------------
  procedure insert_file_meta_data (
    i_keyword               in file_meta_data.keyword%type,
    i_filename_match        in file_meta_data.filename_match%type,
    i_fad_id                in file_meta_data.fad_id%type,
    i_character_set         in file_meta_data.character_set%type,
    i_delimiter             in file_meta_data.delimiter%type,
    i_enclosure             in file_meta_data.enclosure%type)
  is
--    l_row file_meta_data%rowtype;
    l_keyword        file_meta_data.keyword%type not null:=i_keyword ;
    l_filename_match         file_meta_data.filename_match%type not null:=i_filename_match;
    l_fad_id file_meta_data.fad_id%type not null:=i_fad_id;
    l_character_set        file_meta_data.character_set%type not null:=i_character_set;
  begin
--    l_row.fmd_id:=file_meta_data_seq.nextval;
--    l_row.timestamp_insert:=systimestamp;
--    l_row.timestamp_update:=l_row.timestamp_insert;
--    l_row.username_insert:=SYS_CONTEXT('USERENV','OS_USER');
--    l_row.username_update:=l_row.username_insert;
--    
--    l_row.keyword:=l_keyword;
--    l_row.filename_match:=l_filename_match;
--    l_row.fad_id:=l_fad_id;
--    l_row.character_set:=l_character_set;
--    -- virtual column...
--    l_row.ora_charset_id:=nls_charset_id(l_character_set);
--    
--    l_row.delimiter:=i_delimiter;
--    l_row.enclosure:=i_enclosure;
    
    insert into file_meta_data (
    FMD_ID,
TIMESTAMP_INSERT, -- default
TIMESTAMP_UPDATE, -- default systimestamp
USERNAME_INSERT,  -- default SYS_CONTEXT('USERENV','OS_USER');
USERNAME_UPDATE,  -- default
KEYWORD,
FILENAME_MATCH,
FAD_ID,
CHARACTER_SET,
DELIMITER,
ENCLOSURE
    )values (
    file_meta_data_seq.nextval,
    systimestamp,
    systimestamp,
    SYS_CONTEXT('USERENV','OS_USER'),
    SYS_CONTEXT('USERENV','OS_USER'),
    l_keyword,
    l_filename_match,
    l_fad_id,
    l_character_set,
    i_delimiter,
    i_enclosure
    );
    commit;
  end insert_file_meta_data;  
--------------------------------------------------------------------------------
  procedure update_file_meta_data (
    i_fmd_id               in file_meta_data.fmd_id%type,
    i_keyword              in file_meta_data.keyword%type,
    i_filename_match       in file_meta_data.filename_match%type,
    i_fad_id               in file_meta_data.fad_id%type,
    i_character_set        in file_meta_data.character_set%type,
    i_delimiter            in file_meta_data.delimiter%type,
    i_enclosure            in file_meta_data.enclosure%type)
  is
    -- TODO validation bei notnull!
  begin
    null;
  end update_file_meta_data;
--------------------------------------------------------------------------------
end di_util;
/