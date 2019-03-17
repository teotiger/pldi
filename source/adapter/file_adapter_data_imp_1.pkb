create or replace package body file_adapter_data_imp_1
as
--------------------------------------------------------------------------------
  procedure insert_file_text_data(
    i_frd_id        in file_raw_data.frd_id%type,
    i_blob          in file_raw_data.blob_value%type,
    i_fmd_id        in file_meta_data.fmd_id%type,
    i_character_set in file_meta_data.character_set%type)
  is
    l_blob blob;
    l_clob clob;
    l_meta file_meta_data%rowtype;
    r simple_integer:=0;
    ---
    procedure dump_str (buf in varchar2) 
    is
      arr   sys.ora_mining_varchar2_nt;--apex_application_global.vc_arr2;
      arr2  sys.ora_mining_varchar2_nt;--apex_application_global.vc_arr2;
      l_row file_text_data%rowtype;
      l_rest   varchar2(4000) := '';
      
      function trimit(i_str in varchar2, i_chr in varchar2) return varchar2 deterministic is
      begin
        return case when i_chr is not null 
                then trim(both l_meta.enclosure from i_str) 
                else i_str
               end;
      end;
    begin
    
      arr := utils.split_varchar2(l_rest || buf, chr(10), l_meta.enclosure);
--      arr := apex_util.string_to_table(l_rest || buf, chr(10));
      for i in 1..arr.count loop
        r:=r+1;
        
        if i < arr.count then
          -- array auseinandernehmen
          arr2 := utils.split_varchar2(arr(i), l_meta.delimiter, l_meta.enclosure);
--          arr2 := apex_util.string_to_table(arr(i), l_meta.delimiter);
          
         
          l_row.frd_id := i_frd_id;--  ,--          number(10, 0),
          l_row.fmd_id := i_fmd_id;--  ,--         number(5, 0),
          l_row.timestamp_insert := systimestamp; -- ,--timestamp not null,
          l_row.sheet_id := null;
          l_row.sheet_name := null;
          l_row.row_number := r;                                                        
          for i in 1..arr2.count loop
            case i
              when 1  then l_row.c001:=trimit(arr2(i), l_meta.enclosure);
              when 2  then l_row.c002:=trimit(arr2(i), l_meta.enclosure);
              when 3  then l_row.c003:=trimit(arr2(i), l_meta.enclosure);
              when 4  then l_row.c004:=trimit(arr2(i), l_meta.enclosure);
              when 5  then l_row.c005:=trimit(arr2(i), l_meta.enclosure);
              when 6  then l_row.c006:=trimit(arr2(i), l_meta.enclosure);
              when 7  then l_row.c007:=trimit(arr2(i), l_meta.enclosure);
              when 8  then l_row.c008:=trimit(arr2(i), l_meta.enclosure);
              when 9  then l_row.c009:=trimit(arr2(i), l_meta.enclosure);
              when 10 then l_row.c010:=trimit(arr2(i), l_meta.enclosure);            
              else null;
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
    select *
      into l_meta
      from file_meta_data
     where fmd_id=i_fmd_id;  
 
    l_blob:=i_blob;
 
    l_clob:=utils.blob_to_clob(
        i_blob_value => l_blob,
        i_charset_id => l_meta.ora_charset_id
      );

    dump_clob(
      l_clob
    );
    
    commit;
    
    if l_meta.plsql_after_processing is not null then
      execute immediate l_meta.plsql_after_processing using i_frd_id;
    end if;
    
  end insert_file_text_data;
--------------------------------------------------------------------------------
end file_adapter_data_imp_1;
/