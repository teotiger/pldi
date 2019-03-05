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
    
    l_fmd_row file_meta_data%rowtype;
    l_sql varchar2(1000 char);
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



    begin
  
      select *
        into l_fmd_row
        from file_meta_data fmd 
       where l_filename like replace(fmd.filename_match, '*', '%');              -- TODO regexp!
            
    
      l_sql:='begin file_adapter_data_imp_'||l_fmd_row.fad_id||'.insert_file_text_data(:0, :1, :2, :3); end;';
      execute immediate l_sql using l_frd_id, l_blob, l_fmd_row.fmd_id, l_fmd_row.character_set;
      
    exception 
      when no_data_found then null;
      when others then
      rollback;
      sys.dbms_output.put_line('AHA!');
      sys.dbms_output.put_line(sqlerrm);
    end;
    
 dbms_output.put_line('aft');     
 
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
          sys.dbms_output.put_line(sqlerrm); 
          sys.dbms_output.put_line(DBMS_UTILITY.format_error_stack); 


return sqlcode;
          
          raise;
          
      end case;
  end insert_file_raw_data;
--------------------------------------------------------------------------------
end di_util;
/