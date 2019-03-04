create or replace package body di.di_file_adapter1
as
--------------------------------------------------------------------------------
  procedure insert_file_text_data(
        i_frd_id        in file_raw_data.frd_id%type,

    i_blob        in file_raw_data.blob_value%type,
    i_fmd_id        in file_meta_data.fmd_id%type,
    i_character_set in file_meta_data.character_set%type)
  is
    l_blob blob;
    l_clob clob;
    l_meta file_meta_data%rowtype;
    ---
    procedure dump_str (buf in varchar2) 
    is
      arr   apex_application_global.vc_arr2;
      arr2  apex_application_global.vc_arr2;
      l_row file_text_data%rowtype;
      l_rest   varchar2(4000) := '';
    begin
      arr := apex_util.string_to_table(l_rest || buf, chr(10));
      for i in 1..arr.count loop
        if i < arr.count then
          -- array auseinandernehmen
          arr2 := apex_util.string_to_table(arr(i),';');                        -- TODO delimiter
         
         
          l_row.frd_id := i_frd_id;--  ,--          number(10, 0),
          l_row.fmd_id := i_fmd_id;--  ,--         number(5, 0),
          l_row.timestamp_insert := systimestamp; -- ,--timestamp not null,
          l_row.sheet_id := null;
          l_row.sheet_name := null;
          l_row.row_number := 1;                                                        
          for i in 1..arr2.count loop
            case i
              when 1 then l_row.c001:=trim(both '"' from arr2(i));          
              when 2 then l_row.c002:=trim(both '"' from arr2(i));          
              when 3 then l_row.c003:=trim(both '"' from arr2(i));          
              when 4 then l_row.c004:=trim(both '"' from arr2(i));          
              when 5 then l_row.c005:=trim(both '"' from arr2(i));          
            end case;
          end loop;
         
          insert into file_text_data values l_row;
          
  
        else
          l_rest := arr(i);
        end if;
      end loop;
    end dump_str;
    ---
    procedure dump_clob (i_clob in out nocopy clob) 
    is
      offset   number := 1;
      amount   number := 15767;
      len      number := dbms_lob.getlength(i_clob);
      buf      varchar2(16767);
    begin
      while offset < len loop
        dbms_lob.read(i_clob,amount,offset,buf);
        offset := offset + amount;
        dump_str(buf);
      end loop;
    end dump_clob;
--------------------------------------------------------------------------------
  begin    
    -- blob_clob
--      di_util.function blob_to_clob (
--      i_blob_value in blob,
--      i_charset_id in number)
--    return clob
    -- clob verstückeln
--    select blob_value
--      into l_blob
--      from file_raw_data
--     where frd_id=i_frd_id;
 dbms_output.put_line('a');     
      l_blob:=i_blob;
 dbms_output.put_line('b' ||i_fmd_id);     
    select *
      into l_meta
      from file_meta_data
     where fmd_id=i_fmd_id;  
           dbms_output.put_line('c');     
 dbms_output.put_line('d');     

    l_clob:=di_util.blob_to_clob(
        i_blob_value => l_blob,
        i_charset_id => l_meta.ora_charset_id
      );
           dbms_output.put_line('e');     

    dump_clob(
      l_clob
    );

     dbms_output.put_line('f');     

    
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
      'ok... adapter1'
    );
--    commit;
--  
    
  end insert_file_text_data;
--------------------------------------------------------------------------------
end di_file_adapter1;
/