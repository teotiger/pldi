create or replace package body di.di_file_adapter1
as
--------------------------------------------------------------------------------
  procedure insert_file_text_data(
    i_frd_id  in file_raw_data.frd_id%type,
    i_fmd_row in file_meta_data%rowtype)
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
      i_fmd_row.fmd_id,
      systimestamp,
      to_number(null),
      to_char(null),
      1,
      'ok... adapter1'
    );
--    commit;
--  
    
  end insert_file_text_data;
--------------------------------------------------------------------------------
end di_file_adapter1;
/