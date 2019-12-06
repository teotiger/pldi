create or replace package body file_raw_data_api
as
--------------------------------------------------------------------------------
--> https://oracle-base.com/articles/8i/import-blob
--------------------------------------------------------------------------------
  function insert_row (
      i_filename    in varchar2,
      i_blob_value  in blob)
    return number
  is
    l_filename file_raw_data.filename%type not null:=i_filename;
    l_blob_value file_raw_data.blob_value%type not null:=i_blob_value;
    l_frd_id file_raw_data.frd_id%type not null:=file_raw_data_seq.nextval;
  begin
    insert into file_raw_data (
      frd_id,
      filename,
      blob_value,
      filesize,
      mimetype,
      username_insert
    ) values (
      l_frd_id,
      l_filename,
      l_blob_value,
      sys.dbms_lob.getlength(l_blob_value),
      utils.mimetype(i_filename => l_filename),
      utils.username
    );
    return l_frd_id;  
  end insert_row;
--------------------------------------------------------------------------------
  procedure insert_row (
    i_filename    in varchar2,
    i_blob_value  in blob)
  is
    l_filename file_raw_data.filename%type not null:=i_filename;
    l_blob_value file_raw_data.blob_value%type not null:=i_blob_value;
    l_frd_id file_raw_data.frd_id%type;
  begin
    l_frd_id:=insert_row(i_filename => l_filename,
                         i_blob_value => l_blob_value);
  end insert_row;
--------------------------------------------------------------------------------
  function insert_row (
      i_filename  in varchar2,
      i_directory in varchar2 default utils.directory_setting)
    return number
  is
    l_filename file_raw_data.filename%type not null:=i_filename;
    l_directory varchar2(30 char) not null:=i_directory;
    l_frd_id file_raw_data.frd_id%type not null:=file_raw_data_seq.nextval;
    l_blob blob;
    l_filesize file_raw_data.filesize%type;
    l_bfile bfile:=bfilename(l_directory, l_filename);
    l_dest_offset integer:=1;
    l_src_offset integer:=1;
  begin
    insert into file_raw_data (
      frd_id,
      filename,
      blob_value,
      filesize,
      mimetype,
      username_insert
    ) values (
      l_frd_id,
      l_filename,
      empty_blob(),
      sys.dbms_lob.getlength(l_bfile),
      utils.mimetype(i_filename => l_filename),
      utils.username
    ) return blob_value into l_blob;

    sys.dbms_lob.fileopen(l_bfile, sys.dbms_lob.file_readonly);
    if sys.dbms_lob.getlength(l_bfile)>0 then
      sys.dbms_lob.loadblobfromfile(dest_lob => l_blob,
                                    src_bfile => l_bfile,
                                    amount => sys.dbms_lob.lobmaxsize, 
                                    dest_offset => l_dest_offset,
                                    src_offset => l_src_offset);
    end if;
    sys.dbms_lob.fileclose(l_bfile);

    return l_frd_id;
  exception when others then
    if sys.dbms_lob.fileisopen(l_bfile)=1 then
      sys.dbms_lob.fileclose(l_bfile);
    end if;
    l_bfile:=null;
    raise;
  end insert_row;
--------------------------------------------------------------------------------
  procedure insert_row (
    i_filename  in varchar2,
    i_directory in varchar2 default utils.directory_setting)
  is
    l_filename file_raw_data.filename%type not null:=i_filename;
    l_directory varchar2(30 char) not null:=i_directory;
    l_frd_id file_raw_data.frd_id%type;
  begin
    l_frd_id:=insert_row(i_filename => l_filename,
                         i_directory => l_directory);
  end insert_row;
--------------------------------------------------------------------------------
  procedure delete_row (i_frd_id in number)
  is
    l_frd_id file_raw_data.frd_id%type not null:=i_frd_id;
  begin
    delete from file_raw_data where frd_id=l_frd_id;
  end delete_row;
--------------------------------------------------------------------------------
  function housekeeping(i_frd_id in number) return number 
  is
    l_frd_id file_raw_data.frd_id%type not null:=i_frd_id;
    l_sum_bytes number;
  begin
    case sign(utils.max_bytes_setting)
      when -1 then null;
      when  0 then delete from file_raw_data;
      when  1 then
        select sum(filesize) 
          into l_sum_bytes 
          from file_raw_data;
        if l_sum_bytes>utils.max_bytes_setting then
          delete from file_raw_data where frd_id in (
            with max_bytes_check as (
              select frd_id, 
                     sum(filesize) over (order by frd_id desc) sum_filesize,
                     case when sum(filesize) over (order by frd_id desc)>
                               utils.max_bytes_setting 
                      then 1 
                      else 0
                     end delete_fl
                  from file_raw_data
              ) select frd_id from max_bytes_check where delete_fl=1
          ) and frd_id!=l_frd_id;
        end if; 
    end case;
    
--    TODO
--returning into https://oracle-base.com/articles/misc/dml-returning-into-clause
-- und dann in file_status_data update auf frd_id=-1
-- TEST für housekeeping noch schreiben!!!
    
    return nvl(sql%rowcount, 0);
  end housekeeping;
--------------------------------------------------------------------------------
end file_raw_data_api;
/