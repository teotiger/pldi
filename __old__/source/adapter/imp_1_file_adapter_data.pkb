create or replace package body imp_1_file_adapter_data
as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_lf constant varchar2(1 char):=chr(10);
  c_cr constant varchar2(1 char):=chr(13);
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure insert_file_text_data(
    i_frd_id            in file_raw_data.frd_id%type,
    i_fmd_id            in file_meta_data.fmd_id%type,
    i_ftd_id            in file_text_data.ftd_id%type,
    i_blob_value        in file_raw_data.blob_value%type,
    i_ora_charset_id    in file_meta_data.ora_charset_id%type,
    i_ora_charset_name  in file_meta_data.ora_charset_name%type)
  is
    c_sp constant varchar2(1 char):=' ';
    l_meta file_meta_data%rowtype;
    l_ridx simple_integer:=0;
    l_rest varchar2(4000 char):='';
    l_clob clob;
    l_last_char varchar2(1 char);
    ---
    function trimit(i_str in varchar2) return varchar2 deterministic is
    begin
      return case when l_meta.enclosure is not null 
              then trim(both l_meta.enclosure from i_str) 
              else i_str
             end;
    end trimit;
    ---
    procedure dump_varchar2(i_buffer in varchar2, i_is_part in boolean) 
    is
      l_row_arr  sys.ora_mining_varchar2_nt;
      l_cell_arr sys.ora_mining_varchar2_nt;
      l_ftd_row  file_text_data%rowtype;
    begin
      l_row_arr := utils.split_varchar2(i_string_value => l_rest||i_buffer, 
                                        -- what happens with windows newline?
                                        --  2 chars CRLF chr(13)||chr(10)
                                        i_delimiter => c_lf,
                                        i_enclosure => l_meta.enclosure,
                                        i_trim_enclosure => false);
      <<row_loop>>
      for i in 1..l_row_arr.count loop
        l_cell_arr := utils.split_varchar2(i_string_value => l_row_arr(i),
                                           i_delimiter => l_meta.delimiter,
                                           i_enclosure => l_meta.enclosure);

        if i=l_row_arr.count and i_is_part then
          l_rest := l_row_arr(i);
        else
          l_ridx:=l_ridx+1;        
          l_ftd_row:=null;
          l_ftd_row.ftd_id := i_ftd_id;
          l_ftd_row.frd_id := i_frd_id;
          l_ftd_row.fmd_id := i_fmd_id;
          l_ftd_row.timestamp_insert := systimestamp;
          l_ftd_row.row_number := l_ridx;                                                        
          <<cell_loop>>
          for j in 1..l_cell_arr.count loop
            case j
              when 1 then l_ftd_row.c001:=trimit(l_cell_arr(j));
              when 2 then l_ftd_row.c002:=trimit(l_cell_arr(j));
              when 3 then l_ftd_row.c003:=trimit(l_cell_arr(j));
              when 4 then l_ftd_row.c004:=trimit(l_cell_arr(j));
              when 5 then l_ftd_row.c005:=trimit(l_cell_arr(j));
              when 6 then l_ftd_row.c006:=trimit(l_cell_arr(j));
              when 7 then l_ftd_row.c007:=trimit(l_cell_arr(j));
              when 8 then l_ftd_row.c008:=trimit(l_cell_arr(j));
              when 9 then l_ftd_row.c009:=trimit(l_cell_arr(j));
              when 10 then l_ftd_row.c010:=trimit(l_cell_arr(j));
              when 11 then l_ftd_row.c011:=trimit(l_cell_arr(j));
              when 12 then l_ftd_row.c012:=trimit(l_cell_arr(j));
              when 13 then l_ftd_row.c013:=trimit(l_cell_arr(j));
              when 14 then l_ftd_row.c014:=trimit(l_cell_arr(j));
              when 15 then l_ftd_row.c015:=trimit(l_cell_arr(j));
              when 16 then l_ftd_row.c016:=trimit(l_cell_arr(j));
              when 17 then l_ftd_row.c017:=trimit(l_cell_arr(j));
              when 18 then l_ftd_row.c018:=trimit(l_cell_arr(j));
              when 19 then l_ftd_row.c019:=trimit(l_cell_arr(j));
              when 20 then l_ftd_row.c020:=trimit(l_cell_arr(j));
              when 21 then l_ftd_row.c021:=trimit(l_cell_arr(j));
              when 22 then l_ftd_row.c022:=trimit(l_cell_arr(j));
              when 23 then l_ftd_row.c023:=trimit(l_cell_arr(j));
              when 24 then l_ftd_row.c024:=trimit(l_cell_arr(j));
              when 25 then l_ftd_row.c025:=trimit(l_cell_arr(j));
              when 26 then l_ftd_row.c026:=trimit(l_cell_arr(j));
              when 27 then l_ftd_row.c027:=trimit(l_cell_arr(j));
              when 28 then l_ftd_row.c028:=trimit(l_cell_arr(j));
              when 29 then l_ftd_row.c029:=trimit(l_cell_arr(j));
              when 30 then l_ftd_row.c030:=trimit(l_cell_arr(j));
              when 31 then l_ftd_row.c031:=trimit(l_cell_arr(j));
              when 32 then l_ftd_row.c032:=trimit(l_cell_arr(j));
              when 33 then l_ftd_row.c033:=trimit(l_cell_arr(j));
              when 34 then l_ftd_row.c034:=trimit(l_cell_arr(j));
              when 35 then l_ftd_row.c035:=trimit(l_cell_arr(j));
              when 36 then l_ftd_row.c036:=trimit(l_cell_arr(j));
              when 37 then l_ftd_row.c037:=trimit(l_cell_arr(j));
              when 38 then l_ftd_row.c038:=trimit(l_cell_arr(j));
              when 39 then l_ftd_row.c039:=trimit(l_cell_arr(j));
              when 40 then l_ftd_row.c040:=trimit(l_cell_arr(j));
              when 41 then l_ftd_row.c041:=trimit(l_cell_arr(j));
              when 42 then l_ftd_row.c042:=trimit(l_cell_arr(j));
              when 43 then l_ftd_row.c043:=trimit(l_cell_arr(j));
              when 44 then l_ftd_row.c044:=trimit(l_cell_arr(j));
              when 45 then l_ftd_row.c045:=trimit(l_cell_arr(j));
              when 46 then l_ftd_row.c046:=trimit(l_cell_arr(j));
              when 47 then l_ftd_row.c047:=trimit(l_cell_arr(j));
              when 48 then l_ftd_row.c048:=trimit(l_cell_arr(j));
              when 49 then l_ftd_row.c049:=trimit(l_cell_arr(j));
              when 50 then l_ftd_row.c050:=trimit(l_cell_arr(j));
              when 51 then l_ftd_row.c051:=trimit(l_cell_arr(j));
              when 52 then l_ftd_row.c052:=trimit(l_cell_arr(j));
              when 53 then l_ftd_row.c053:=trimit(l_cell_arr(j));
              when 54 then l_ftd_row.c054:=trimit(l_cell_arr(j));
              when 55 then l_ftd_row.c055:=trimit(l_cell_arr(j));
              when 56 then l_ftd_row.c056:=trimit(l_cell_arr(j));
              when 57 then l_ftd_row.c057:=trimit(l_cell_arr(j));
              when 58 then l_ftd_row.c058:=trimit(l_cell_arr(j));
              when 59 then l_ftd_row.c059:=trimit(l_cell_arr(j));
              when 60 then l_ftd_row.c060:=trimit(l_cell_arr(j));
              when 61 then l_ftd_row.c061:=trimit(l_cell_arr(j));
              when 62 then l_ftd_row.c062:=trimit(l_cell_arr(j));
              when 63 then l_ftd_row.c063:=trimit(l_cell_arr(j));
              when 64 then l_ftd_row.c064:=trimit(l_cell_arr(j));
              when 65 then l_ftd_row.c065:=trimit(l_cell_arr(j));
              when 66 then l_ftd_row.c066:=trimit(l_cell_arr(j));
              when 67 then l_ftd_row.c067:=trimit(l_cell_arr(j));
              when 68 then l_ftd_row.c068:=trimit(l_cell_arr(j));
              when 69 then l_ftd_row.c069:=trimit(l_cell_arr(j));
              when 70 then l_ftd_row.c070:=trimit(l_cell_arr(j));
              when 71 then l_ftd_row.c071:=trimit(l_cell_arr(j));
              when 72 then l_ftd_row.c072:=trimit(l_cell_arr(j));
              when 73 then l_ftd_row.c073:=trimit(l_cell_arr(j));
              when 74 then l_ftd_row.c074:=trimit(l_cell_arr(j));
              when 75 then l_ftd_row.c075:=trimit(l_cell_arr(j));
              when 76 then l_ftd_row.c076:=trimit(l_cell_arr(j));
              when 77 then l_ftd_row.c077:=trimit(l_cell_arr(j));
              when 78 then l_ftd_row.c078:=trimit(l_cell_arr(j));
              when 79 then l_ftd_row.c079:=trimit(l_cell_arr(j));
              when 80 then l_ftd_row.c080:=trimit(l_cell_arr(j));
              when 81 then l_ftd_row.c081:=trimit(l_cell_arr(j));
              when 82 then l_ftd_row.c082:=trimit(l_cell_arr(j));
              when 83 then l_ftd_row.c083:=trimit(l_cell_arr(j));
              when 84 then l_ftd_row.c084:=trimit(l_cell_arr(j));
              when 85 then l_ftd_row.c085:=trimit(l_cell_arr(j));
              when 86 then l_ftd_row.c086:=trimit(l_cell_arr(j));
              when 87 then l_ftd_row.c087:=trimit(l_cell_arr(j));
              when 88 then l_ftd_row.c088:=trimit(l_cell_arr(j));
              when 89 then l_ftd_row.c089:=trimit(l_cell_arr(j));
              when 90 then l_ftd_row.c090:=trimit(l_cell_arr(j));
              when 91 then l_ftd_row.c091:=trimit(l_cell_arr(j));
              when 92 then l_ftd_row.c092:=trimit(l_cell_arr(j));
              when 93 then l_ftd_row.c093:=trimit(l_cell_arr(j));
              when 94 then l_ftd_row.c094:=trimit(l_cell_arr(j));
              when 95 then l_ftd_row.c095:=trimit(l_cell_arr(j));
              when 96 then l_ftd_row.c096:=trimit(l_cell_arr(j));
              when 97 then l_ftd_row.c097:=trimit(l_cell_arr(j));
              when 98 then l_ftd_row.c098:=trimit(l_cell_arr(j));
              when 99 then l_ftd_row.c099:=trimit(l_cell_arr(j));
              when 100 then l_ftd_row.c100:=trimit(l_cell_arr(j));
              when 101 then l_ftd_row.c101:=trimit(l_cell_arr(j));
              when 102 then l_ftd_row.c102:=trimit(l_cell_arr(j));
              when 103 then l_ftd_row.c103:=trimit(l_cell_arr(j));
              when 104 then l_ftd_row.c104:=trimit(l_cell_arr(j));
              when 105 then l_ftd_row.c105:=trimit(l_cell_arr(j));
              when 106 then l_ftd_row.c106:=trimit(l_cell_arr(j));
              when 107 then l_ftd_row.c107:=trimit(l_cell_arr(j));
              when 108 then l_ftd_row.c108:=trimit(l_cell_arr(j));
              when 109 then l_ftd_row.c109:=trimit(l_cell_arr(j));
              when 110 then l_ftd_row.c110:=trimit(l_cell_arr(j));
              when 111 then l_ftd_row.c111:=trimit(l_cell_arr(j));
              when 112 then l_ftd_row.c112:=trimit(l_cell_arr(j));
              when 113 then l_ftd_row.c113:=trimit(l_cell_arr(j));
              when 114 then l_ftd_row.c114:=trimit(l_cell_arr(j));
              when 115 then l_ftd_row.c115:=trimit(l_cell_arr(j));
              when 116 then l_ftd_row.c116:=trimit(l_cell_arr(j));
              when 117 then l_ftd_row.c117:=trimit(l_cell_arr(j));
              when 118 then l_ftd_row.c118:=trimit(l_cell_arr(j));
              when 119 then l_ftd_row.c119:=trimit(l_cell_arr(j));
              when 120 then l_ftd_row.c120:=trimit(l_cell_arr(j));
              when 121 then l_ftd_row.c121:=trimit(l_cell_arr(j));
              when 122 then l_ftd_row.c122:=trimit(l_cell_arr(j));
              when 123 then l_ftd_row.c123:=trimit(l_cell_arr(j));
              when 124 then l_ftd_row.c124:=trimit(l_cell_arr(j));
              when 125 then l_ftd_row.c125:=trimit(l_cell_arr(j));
              when 126 then l_ftd_row.c126:=trimit(l_cell_arr(j));
              when 127 then l_ftd_row.c127:=trimit(l_cell_arr(j));
              when 128 then l_ftd_row.c128:=trimit(l_cell_arr(j));
              when 129 then l_ftd_row.c129:=trimit(l_cell_arr(j));
              when 130 then l_ftd_row.c130:=trimit(l_cell_arr(j));
              when 131 then l_ftd_row.c131:=trimit(l_cell_arr(j));
              when 132 then l_ftd_row.c132:=trimit(l_cell_arr(j));
              when 133 then l_ftd_row.c133:=trimit(l_cell_arr(j));
              when 134 then l_ftd_row.c134:=trimit(l_cell_arr(j));
              when 135 then l_ftd_row.c135:=trimit(l_cell_arr(j));
              when 136 then l_ftd_row.c136:=trimit(l_cell_arr(j));
              when 137 then l_ftd_row.c137:=trimit(l_cell_arr(j));
              when 138 then l_ftd_row.c138:=trimit(l_cell_arr(j));
              when 139 then l_ftd_row.c139:=trimit(l_cell_arr(j));
              when 140 then l_ftd_row.c140:=trimit(l_cell_arr(j));
              when 141 then l_ftd_row.c141:=trimit(l_cell_arr(j));
              when 142 then l_ftd_row.c142:=trimit(l_cell_arr(j));
              when 143 then l_ftd_row.c143:=trimit(l_cell_arr(j));
              when 144 then l_ftd_row.c144:=trimit(l_cell_arr(j));
              when 145 then l_ftd_row.c145:=trimit(l_cell_arr(j));
              when 146 then l_ftd_row.c146:=trimit(l_cell_arr(j));
              when 147 then l_ftd_row.c147:=trimit(l_cell_arr(j));
              when 148 then l_ftd_row.c148:=trimit(l_cell_arr(j));
              when 149 then l_ftd_row.c149:=trimit(l_cell_arr(j));
              when 150 then l_ftd_row.c150:=trimit(l_cell_arr(j));
              when 151 then l_ftd_row.c151:=trimit(l_cell_arr(j));
              when 152 then l_ftd_row.c152:=trimit(l_cell_arr(j));
              when 153 then l_ftd_row.c153:=trimit(l_cell_arr(j));
              when 154 then l_ftd_row.c154:=trimit(l_cell_arr(j));
              when 155 then l_ftd_row.c155:=trimit(l_cell_arr(j));
              when 156 then l_ftd_row.c156:=trimit(l_cell_arr(j));
              when 157 then l_ftd_row.c157:=trimit(l_cell_arr(j));
              when 158 then l_ftd_row.c158:=trimit(l_cell_arr(j));
              when 159 then l_ftd_row.c159:=trimit(l_cell_arr(j));
              when 160 then l_ftd_row.c160:=trimit(l_cell_arr(j));
              when 161 then l_ftd_row.c161:=trimit(l_cell_arr(j));
              when 162 then l_ftd_row.c162:=trimit(l_cell_arr(j));
              when 163 then l_ftd_row.c163:=trimit(l_cell_arr(j));
              when 164 then l_ftd_row.c164:=trimit(l_cell_arr(j));
              when 165 then l_ftd_row.c165:=trimit(l_cell_arr(j));
              when 166 then l_ftd_row.c166:=trimit(l_cell_arr(j));
              when 167 then l_ftd_row.c167:=trimit(l_cell_arr(j));
              when 168 then l_ftd_row.c168:=trimit(l_cell_arr(j));
              when 169 then l_ftd_row.c169:=trimit(l_cell_arr(j));
              when 170 then l_ftd_row.c170:=trimit(l_cell_arr(j));
              when 171 then l_ftd_row.c171:=trimit(l_cell_arr(j));
              when 172 then l_ftd_row.c172:=trimit(l_cell_arr(j));
              when 173 then l_ftd_row.c173:=trimit(l_cell_arr(j));
              when 174 then l_ftd_row.c174:=trimit(l_cell_arr(j));
              when 175 then l_ftd_row.c175:=trimit(l_cell_arr(j));
              when 176 then l_ftd_row.c176:=trimit(l_cell_arr(j));
              when 177 then l_ftd_row.c177:=trimit(l_cell_arr(j));
              when 178 then l_ftd_row.c178:=trimit(l_cell_arr(j));
              when 179 then l_ftd_row.c179:=trimit(l_cell_arr(j));
              when 180 then l_ftd_row.c180:=trimit(l_cell_arr(j));
              when 181 then l_ftd_row.c181:=trimit(l_cell_arr(j));
              when 182 then l_ftd_row.c182:=trimit(l_cell_arr(j));
              when 183 then l_ftd_row.c183:=trimit(l_cell_arr(j));
              when 184 then l_ftd_row.c184:=trimit(l_cell_arr(j));
              when 185 then l_ftd_row.c185:=trimit(l_cell_arr(j));
              when 186 then l_ftd_row.c186:=trimit(l_cell_arr(j));
              when 187 then l_ftd_row.c187:=trimit(l_cell_arr(j));
              when 188 then l_ftd_row.c188:=trimit(l_cell_arr(j));
              when 189 then l_ftd_row.c189:=trimit(l_cell_arr(j));
              when 190 then l_ftd_row.c190:=trimit(l_cell_arr(j));
              when 191 then l_ftd_row.c191:=trimit(l_cell_arr(j));
              when 192 then l_ftd_row.c192:=trimit(l_cell_arr(j));
              when 193 then l_ftd_row.c193:=trimit(l_cell_arr(j));
              when 194 then l_ftd_row.c194:=trimit(l_cell_arr(j));
              when 195 then l_ftd_row.c195:=trimit(l_cell_arr(j));
              when 196 then l_ftd_row.c196:=trimit(l_cell_arr(j));
              when 197 then l_ftd_row.c197:=trimit(l_cell_arr(j));
              when 198 then l_ftd_row.c198:=trimit(l_cell_arr(j));
              when 199 then l_ftd_row.c199:=trimit(l_cell_arr(j));
              when 200 then l_ftd_row.c200:=trimit(l_cell_arr(j));
                else null;
            end case;
          end loop cell_loop;
          insert into file_text_data values l_ftd_row;
        end if;
      end loop row_loop;
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
        dump_varchar2(l_buffer, l_offset < l_length);
      end loop;
    end dump_clob;
--------------------------------------------------------------------------------
  begin 
    -- delimiter and enclosure value is needed for helper procedures/functions
    select *
      into l_meta
      from file_meta_data
     where fmd_id=i_fmd_id;  
 
    l_clob:=utils.blob_to_clob(i_blob_value => i_blob_value,
                               i_ora_charset_id => i_ora_charset_id);
    
    -- remove trailing spaces and linebreaks
    l_last_char:=sys.dbms_lob.substr(
                    lob_loc => l_clob,
                    amount => 1,
                    offset => sys.dbms_lob.getlength(l_clob) - 1);
    while l_last_char in (c_lf, c_cr, c_sp)
    loop
      l_clob:=rtrim(l_clob, c_lf);
      l_clob:=rtrim(l_clob, c_cr);
      l_clob:=rtrim(l_clob, c_sp);
      l_last_char:=sys.dbms_lob.substr(
                    lob_loc => l_clob,
                    amount => 1,
                    offset => sys.dbms_lob.getlength(l_clob) - 1);
    end loop;
    
    dump_clob(i_plain_text => l_clob);    
    commit;
    
  end insert_file_text_data;
--------------------------------------------------------------------------------
end imp_1_file_adapter_data;
/