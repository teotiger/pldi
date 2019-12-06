create or replace package body file_status_data_api
as
--------------------------------------------------------------------------------
  function insert_row (i_filename in varchar2) return number
  is
    pragma autonomous_transaction;
    l_filename file_status_data.filename%type not null:=i_filename;
    l_fsd_id file_status_data.fsd_id%type not null:=file_status_data_seq.nextval;
  begin
    insert into file_status_data (
      fsd_id,
      filename,
      username_insert,
      username_update
    ) values (
      l_fsd_id,
      l_filename,
      utils.username,
      utils.username
    );
    commit;
    return l_fsd_id;
  end insert_row;
--------------------------------------------------------------------------------
  procedure insert_row (i_filename in varchar2)
  is
    l_filename file_status_data.filename%type not null:=i_filename;
    l_fsd_id file_status_data.fsd_id%type;
  begin
    l_fsd_id:=insert_row(i_filename => l_filename);
  end insert_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fsd_id    in number,
    i_frd_id    in number,
    i_seconds_1 in number)
  is  
    pragma autonomous_transaction;
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
    l_frd_id file_status_data.frd_id%type not null:=i_frd_id;
    l_seconds_1 file_status_data.seconds_1%type not null:=i_seconds_1;
  begin
    update file_status_data
       set frd_id=l_frd_id,
           seconds_1=l_seconds_1
     where fsd_id=l_fsd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fsd_id    in number,
    i_ftd_id    in number,
    i_fmd_id    in number,
    i_fad_id    in number,
    i_seconds_2 in number)
  is  
    pragma autonomous_transaction;
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
    l_ftd_id file_status_data.ftd_id%type not null:=i_ftd_id;
    l_fmd_id file_status_data.fmd_id%type not null:=i_fmd_id;
    l_fad_id file_status_data.fad_id%type not null:=i_fad_id;
    l_seconds_2 file_status_data.seconds_2%type not null:=i_seconds_2;
  begin
    update file_status_data
       set ftd_id=l_ftd_id,
           fmd_id=l_fmd_id,
           fad_id=l_fad_id,
           seconds_2=l_seconds_2
     where fsd_id=l_fsd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fsd_id    in number,
    i_frd_id    in number,
    i_seconds_3 in number)
  is  
    pragma autonomous_transaction;
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
    l_frd_id file_status_data.frd_id%type not null:=i_frd_id;
    l_seconds_3 file_status_data.seconds_3%type not null:=i_seconds_3;
  begin
    update file_status_data
       set frd_id=l_frd_id,
           seconds_3=l_seconds_3
     where fsd_id=l_fsd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fsd_id    in number,
    i_frd_id    in number,
    i_seconds_4 in number)
  is  
    pragma autonomous_transaction;
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
    l_frd_id file_status_data.frd_id%type not null:=i_frd_id;
    l_seconds_4 file_status_data.seconds_4%type not null:=i_seconds_4;
  begin
    update file_status_data
       set frd_id=l_frd_id,
           seconds_4=l_seconds_4
     where fsd_id=l_fsd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fsd_id        in number,
    i_error_message in varchar2)
  is
    pragma autonomous_transaction;
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
    l_error_message file_status_data.error_message%type not null:=i_error_message;
  begin
    update file_status_data
       set error_message=l_error_message
     where fsd_id=l_fsd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure delete_row (i_fsd_id in number) is
    l_fsd_id file_status_data.fsd_id%type not null:=i_fsd_id;
  begin
    delete from file_status_data where fsd_id=l_fsd_id;
  end delete_row;
--------------------------------------------------------------------------------
  procedure delete_rows (i_filename in varchar2)
  is
    pragma autonomous_transaction;
  begin
    delete from file_status_data where filename=i_filename;
    commit;
  end delete_rows;
--------------------------------------------------------------------------------
end file_status_data_api;
/