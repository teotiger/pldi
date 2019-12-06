create or replace package body file_status_data_api
as
--------------------------------------------------------------------------------
  procedure insert_row (
    i_frd_id        in file_raw_data.frd_id%type,
    i_filename      in file_raw_data.filename%type,
    i_filesize      in file_raw_data.filesize%type,
    i_seconds_step1 in file_status_data.seconds_step1%type)
  is
    -- TODO null check
  begin
    insert into file_status_data (
      fsd_id,
      frd_id,
      filename,
      filesize,
      seconds_step1
    ) values (
      file_status_data_seq.nextval,
      i_frd_id,
      i_filename,
      i_filesize,
      i_seconds_step1
    );
    commit;
  end;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fsd_id        in file_status_data.fsd_id%type,
    i_fmd_id        in file_meta_data.fmd_id%type,
    i_fad_id        in file_adapter_data.fad_id%type,
    i_ftd_id        in file_text_data.ftd_id%type,
    i_seconds_step2 in file_status_data.seconds_step2%type)
  is
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
    l_seconds_step2 file_status_data.seconds_step3%type not null
      :=i_seconds_step2;
  begin
    update file_status_data
       set seconds_step2=l_seconds_step2,
       fmd_id=i_fmd_id,
       fad_id=i_fad_id,
       ftd_id=i_ftd_id
     where fsd_id=l_fsd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fsd_id        in file_status_data.fsd_id%type,
    i_seconds_step3 in file_status_data.seconds_step3%type)
  is
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
    l_seconds_step3 file_status_data.seconds_step3%type not null
      :=i_seconds_step3;
  begin
    update file_status_data
       set seconds_step3=l_seconds_step3
     where fsd_id=l_fsd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fsd_id        in file_status_data.fsd_id%type,
    i_error_message in file_status_data.error_message%type)
  is
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
    l_error_message file_status_data.error_message%type not null
      :=i_error_message;
  begin
    update file_status_data
       set error_message=l_error_message
     where fsd_id=l_fsd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure delete_row (
    i_fsd_id in file_status_data.fsd_id%type)
  is
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
  begin
    delete file_status_data 
     where fsd_id=l_fsd_id;
    commit;
  end delete_row;
--------------------------------------------------------------------------------
end file_status_data_api;
/