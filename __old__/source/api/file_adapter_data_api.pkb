create or replace package body file_adapter_data_api
as
--------------------------------------------------------------------------------
  procedure insert_row (
    i_description_text in file_adapter_data.description_text%type)
  is
    l_description_text file_adapter_data.description_text%type not null
      :=i_description_text;
  begin
    insert into file_adapter_data (
      fad_id,
      description_text
    ) values (
      file_adapter_data_seq.nextval,
      l_description_text
    );
    commit;
  end insert_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fad_id in file_adapter_data.fad_id%type,
    i_description_text in file_adapter_data.description_text%type)
  is
    l_fad_id file_adapter_data.fad_id%type not null:=i_fad_id;
    l_description_text file_adapter_data.description_text%type not null
      :=i_description_text;
  begin
    update file_adapter_data
       set description_text=l_description_text
     where fad_id=l_fad_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure delete_row (
    i_fad_id in file_adapter_data.fad_id%type)
  is
    l_fad_id file_adapter_data.fad_id%type not null:=i_fad_id;
  begin
    delete file_adapter_data 
     where fad_id=l_fad_id;
    commit;
  end delete_row;
--------------------------------------------------------------------------------
end file_adapter_data_api;
/