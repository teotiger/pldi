create or replace package body file_adapter_data_imp_2
as
--------------------------------------------------------------------------------
  procedure insert_file_text_data(
    i_frd_id        in file_raw_data.frd_id%type,
    i_fmd_id        in file_meta_data.fmd_id%type,
    i_character_set in file_meta_data.character_set%type)
  is
  begin    
    -- bessre => regexp
    
    
    -- devel
    insert into file_text_data (
frd_id   ,--          number(10, 0),
  fmd_id    ,--         number(5, 0),
  timestamp_insert   ,--timestamp not null,
  sheet_id           ,--number(2, 0),
  sheet_name        ,-- varchar2(255 char),
  row_number        ,--- number(8, 0) not null,
  c001             --  varchar2(4000 char),
    )
    values (
      i_frd_id,
      i_fmd_id,
      systimestamp,
      to_number(null),
      to_char(null),
      1,
      'ok... adapter2'
    );
--    commit;
--  
    
  end insert_file_text_data;
--------------------------------------------------------------------------------
end file_adapter_data_imp_2;
/