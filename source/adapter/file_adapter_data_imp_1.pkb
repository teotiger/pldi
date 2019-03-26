create or replace package body file_adapter_data_imp_1
as
--------------------------------------------------------------------------------
  procedure insert_file_text_data(
    i_frd_id      in file_raw_data.frd_id%type,
    i_blob        in file_raw_data.blob_value%type,
    i_fmd_id      in file_meta_data.fmd_id%type,
    i_charset_id  in file_meta_data.ora_charset_id%type,
    i_ftd_id      in file_text_data.ftd_id%type)
  is
    l_meta file_meta_data%rowtype;
    l_ridx simple_integer:=0;
    ---
    function trimit(i_str in varchar2) return varchar2 deterministic is
    begin
      return case when l_meta.enclosure is not null 
              then trim(both l_meta.enclosure from i_str) 
              else i_str
             end;
    end trimit;
    ---
    procedure dump_varchar2(i_buffer in varchar2) 
    is
      c_eol constant varchar2(1 char):=chr(10);
      l_row_arr  sys.ora_mining_varchar2_nt;
      l_cell_arr sys.ora_mining_varchar2_nt;
      l_ftd_row  file_text_data%rowtype;
      l_rest     varchar2(4000 char):='';
    begin
      l_row_arr := utils.split_varchar2(i_string_value => l_rest||i_buffer, 
                                        i_delimiter => c_eol,
                                        i_enclosure => l_meta.enclosure);
      for i in 1..l_row_arr.count loop
        l_ridx:=l_ridx+1;        
        if i<l_row_arr.count then
          l_cell_arr := utils.split_varchar2(i_string_value => l_row_arr(i),
                                             i_delimiter => l_meta.delimiter,
                                             i_enclosure => l_meta.enclosure);
          l_ftd_row.ftd_id := i_ftd_id;
          l_ftd_row.frd_id := i_frd_id;
          l_ftd_row.fmd_id := i_fmd_id;
          l_ftd_row.timestamp_insert := systimestamp;
          l_ftd_row.row_number := l_ridx;                                                        
          for i in 1..l_cell_arr.count loop
            case i
              when 1  then l_ftd_row.c001:=trimit(l_cell_arr(i));
              when 2  then l_ftd_row.c002:=trimit(l_cell_arr(i));
              when 3  then l_ftd_row.c003:=trimit(l_cell_arr(i));
              when 4  then l_ftd_row.c004:=trimit(l_cell_arr(i));
              when 5  then l_ftd_row.c005:=trimit(l_cell_arr(i));
              when 6  then l_ftd_row.c006:=trimit(l_cell_arr(i));
              when 7  then l_ftd_row.c007:=trimit(l_cell_arr(i));
              when 8  then l_ftd_row.c008:=trimit(l_cell_arr(i));
              when 9  then l_ftd_row.c009:=trimit(l_cell_arr(i));
              when 10 then l_ftd_row.c010:=trimit(l_cell_arr(i));            
              when 11 then l_ftd_row.c011:=trimit(l_cell_arr(i));            
              when 12 then l_ftd_row.c012:=trimit(l_cell_arr(i));            
              when 13 then l_ftd_row.c013:=trimit(l_cell_arr(i));            
              when 14 then l_ftd_row.c014:=trimit(l_cell_arr(i));            
              when 15 then l_ftd_row.c015:=trimit(l_cell_arr(i));            
              when 16 then l_ftd_row.c016:=trimit(l_cell_arr(i));            
              when 17 then l_ftd_row.c017:=trimit(l_cell_arr(i));            
              when 18 then l_ftd_row.c018:=trimit(l_cell_arr(i));            
              when 19 then l_ftd_row.c019:=trimit(l_cell_arr(i));            
              when 20 then l_ftd_row.c020:=trimit(l_cell_arr(i));            
              when 21 then l_ftd_row.c021:=trimit(l_cell_arr(i));            
              when 22 then l_ftd_row.c022:=trimit(l_cell_arr(i));            
              when 23 then l_ftd_row.c023:=trimit(l_cell_arr(i));            
              when 24 then l_ftd_row.c024:=trimit(l_cell_arr(i));            
              when 25 then l_ftd_row.c025:=trimit(l_cell_arr(i));            
              when 26 then l_ftd_row.c026:=trimit(l_cell_arr(i));            
              when 27 then l_ftd_row.c027:=trimit(l_cell_arr(i));            
              when 28 then l_ftd_row.c028:=trimit(l_cell_arr(i));            
              when 29 then l_ftd_row.c029:=trimit(l_cell_arr(i));            
              when 30 then l_ftd_row.c030:=trimit(l_cell_arr(i));            
              when 31 then l_ftd_row.c031:=trimit(l_cell_arr(i));            
              when 32 then l_ftd_row.c032:=trimit(l_cell_arr(i));            
              when 33 then l_ftd_row.c033:=trimit(l_cell_arr(i));            
              when 34 then l_ftd_row.c034:=trimit(l_cell_arr(i));            
              when 35 then l_ftd_row.c035:=trimit(l_cell_arr(i));            
              when 36 then l_ftd_row.c036:=trimit(l_cell_arr(i));            
              when 37 then l_ftd_row.c037:=trimit(l_cell_arr(i));            
              when 38 then l_ftd_row.c038:=trimit(l_cell_arr(i));            
              when 39 then l_ftd_row.c039:=trimit(l_cell_arr(i));            
              when 40 then l_ftd_row.c040:=trimit(l_cell_arr(i));
              when 41 then l_ftd_row.c041:=trimit(l_cell_arr(i));            
              when 42 then l_ftd_row.c042:=trimit(l_cell_arr(i));            
              when 43 then l_ftd_row.c043:=trimit(l_cell_arr(i));            
              when 44 then l_ftd_row.c044:=trimit(l_cell_arr(i));            
              when 45 then l_ftd_row.c045:=trimit(l_cell_arr(i));            
              when 46 then l_ftd_row.c046:=trimit(l_cell_arr(i));            
              when 47 then l_ftd_row.c047:=trimit(l_cell_arr(i));            
              when 48 then l_ftd_row.c048:=trimit(l_cell_arr(i));            
              when 49 then l_ftd_row.c049:=trimit(l_cell_arr(i));            
              when 50 then l_ftd_row.c050:=trimit(l_cell_arr(i));
                else null;
            end case;
          end loop;
          insert into file_text_data values l_ftd_row;          
        else
          l_rest := l_row_arr(i);
        end if;
      end loop;
    end dump_varchar2;
    ---
    procedure dump_clob(i_plain_text in clob)
    is
      l_offset  number := 1;
      l_amount  number := 15767;
      l_length  number := sys.dbms_lob.getlength(i_plain_text);
      l_buffer  varchar2(16767 char);
    begin
      while l_offset < l_length 
      loop
        sys.dbms_lob.read(i_plain_text, l_amount, l_offset, l_buffer);
        l_offset := l_offset + l_amount;
        dump_varchar2(l_buffer);
      end loop;
    end dump_clob;
--------------------------------------------------------------------------------
  begin 
    -- delimiter and enclosure value is needed for helper procedures/functions
    select *
      into l_meta
      from file_meta_data
     where fmd_id=i_fmd_id;  
 
    dump_clob(
      i_plain_text => utils.blob_to_clob(i_blob_value => i_blob,
                                         i_charset_id => i_charset_id)
    );    
    commit;
    
  end insert_file_text_data;
--------------------------------------------------------------------------------
end file_adapter_data_imp_1;
/