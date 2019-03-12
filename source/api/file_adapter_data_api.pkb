create or replace package body file_adapter_data_api
as
--------------------------------------------------------------------------------
procedure insert_row (
    i_description_text in file_adapter_data.description_text%type)
  is
    l_description_text  file_adapter_data.description_text%type not null:=i_description_text;
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
  procedure update_row
  is
  begin
    null;
  end update_row;
--------------------------------------------------------------------------------
  procedure delete_row
  is
  begin
    null;
  end delete_row;
--------------------------------------------------------------------------------
end file_adapter_data_api;
/