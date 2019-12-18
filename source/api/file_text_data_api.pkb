create or replace package body file_text_data_api
as
--------------------------------------------------------------------------------
  procedure insert_rows (
    i_frd_id in  number,
    o_ftd_id out number,
    o_fmd_id out number,
    o_fad_id out number)
  is
    l_frd_id file_raw_data.frd_id%type not null:=i_frd_id;
    l_filename file_raw_data.filename%type;
    l_blob_value file_raw_data.blob_value%type;
    l_fmd_row file_meta_data%rowtype;
    l_sql varchar2(4000 char);
  begin
    select filename, blob_value
      into l_filename, l_blob_value
      from file_raw_data
     where frd_id=l_frd_id;

    select *
      into l_fmd_row
      from file_meta_data
     where l_filename like case when filter_is_regular_expression=0 
                            then replace(filename_match_filter, '*', '%')
                            else l_filename
                           end
       and regexp_like(l_filename, case when filter_is_regular_expression=1
                                    then filename_match_filter 
                                    else l_filename
                                   end);

    o_ftd_id:=file_text_data_seq.nextval;
    o_fmd_id :=l_fmd_row.fmd_id;
    o_fad_id:=l_fmd_row.fad_id;

    l_sql:='begin imp_'||l_fmd_row.fad_id||'_file_adapter_data'||
           '.insert_file_text_data(:1, :2, :3, :4, :5, :6); end;';
    execute immediate l_sql using l_frd_id,
                                  l_fmd_row.fmd_id,
                                  o_ftd_id,
                                  l_blob_value,
                                  l_fmd_row.ora_charset_id,
                                  l_fmd_row.ora_charset_name;
  end insert_rows;
--------------------------------------------------------------------------------
  procedure delete_rows (i_ftd_id in number)
  is
    l_ftd_id file_text_data.ftd_id%type not null:=i_ftd_id;
  begin
    delete from file_text_data where ftd_id=l_ftd_id;
  end delete_rows;
--------------------------------------------------------------------------------
end file_text_data_api;
/