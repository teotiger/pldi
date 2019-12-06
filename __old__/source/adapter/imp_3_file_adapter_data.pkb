create or replace package body imp_3_file_adapter_data
as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

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
    c_dat_fmt constant varchar2(30 char):='MM-DD-YYYY';
    l_cr pls_integer:=0;
    l_ftd_row file_text_data%rowtype;
    procedure insert_row is
    begin
      insert into file_text_data values l_ftd_row;
    end;
  begin 
    for i in (
      select * from table( as_read_xlsx.read( i_blob_value ) )
    ) loop
      if l_cr<>i.row_nr then
        if l_cr!=0 then
          insert_row;
        end if;
        l_cr:=i.row_nr;
        l_ftd_row:=null;
        l_ftd_row.ftd_id:=i_ftd_id;
        l_ftd_row.frd_id:=i_frd_id;
        l_ftd_row.fmd_id:=i_fmd_id;
        l_ftd_row.timestamp_insert:=systimestamp;
        l_ftd_row.sheet_id:=i.sheet_nr;
        l_ftd_row.sheet_name:=i.sheet_name;
        l_ftd_row.row_number:=i.row_nr;
      end if;
      
      case i.col_nr
        when 1 then l_ftd_row.c001:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 2 then l_ftd_row.c002:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 3 then l_ftd_row.c003:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 4 then l_ftd_row.c004:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 5 then l_ftd_row.c005:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 6 then l_ftd_row.c006:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 7 then l_ftd_row.c007:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 8 then l_ftd_row.c008:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 9 then l_ftd_row.c009:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 10 then l_ftd_row.c010:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 11 then l_ftd_row.c011:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 12 then l_ftd_row.c012:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 13 then l_ftd_row.c013:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 14 then l_ftd_row.c014:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 15 then l_ftd_row.c015:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        when 16 then l_ftd_row.c016:=coalesce(i.string_val, to_char(i.number_val, '9999999D9', 'NLS_NUMERIC_CHARACTERS=''.,'''), to_char(i.date_val, c_dat_fmt));
        else null;
      end case;
    end loop;
    insert_row;
    commit;
  exception when others then
    rollback;
  end insert_file_text_data;
--------------------------------------------------------------------------------
end imp_3_file_adapter_data;
/