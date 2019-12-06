create or replace package body file_text_data_api
as
--------------------------------------------------------------------------------
  procedure insert_rows (
    i_frd_id  in file_raw_data.frd_id%type)
  is
    l_ftd_id file_text_data.ftd_id%type;
  begin
    l_ftd_id:=insert_rows(i_frd_id);
  end insert_rows;
--------------------------------------------------------------------------------
  function insert_rows (
      i_frd_id  in file_raw_data.frd_id%type)
    return number
  is
    l_frd_id  file_raw_data.frd_id%type not null:=i_frd_id;
    l_ftd_id  file_text_data.ftd_id%type;
    l_fmd_row file_meta_data%rowtype;
    l_frd_row file_raw_data%rowtype;
    l_sql     varchar2(1000 char);
  begin
    
    select *
      into l_frd_row
      from file_raw_data
     where frd_id=l_frd_id;
    
    select *
      into l_fmd_row
      from file_meta_data
     where l_frd_row.filename like case when filter_is_regular_expression=0 
                                    then replace(filename_match_filter, '*', '%')
                                    else l_frd_row.filename
                                   end
       and regexp_like(l_frd_row.filename, case when filter_is_regular_expression=1 
                                            then filename_match_filter 
                                            else l_frd_row.filename
                                           end);
        
    l_ftd_id := file_text_data_seq.nextval;    
    l_sql:='begin imp_'||l_fmd_row.fad_id||'_file_adapter_data'||
           '.insert_file_text_data(:1, :2, :3, :4, :5, :6); end;';
    execute immediate l_sql using l_frd_row.frd_id,
                                  l_fmd_row.fmd_id,
                                  l_ftd_id,
                                  l_frd_row.blob_value,
                                  l_fmd_row.ora_charset_id,
                                  l_fmd_row.ora_charset_name;                                  

    return l_ftd_id;
  
  exception when no_data_found then
    return null;
  end insert_rows;
--------------------------------------------------------------------------------
  procedure insert_rows (
    i_frd_id    in  file_raw_data.frd_id%type,
    o_ftd_id    out file_text_data.ftd_id%type,
    o_fmd_id    out file_meta_data.fmd_id%type,
    o_fad_id    out file_adapter_data.fad_id%type,
    o_filename  out nocopy file_raw_data.filename%type,
    o_filesize  out nocopy file_raw_data.filename%type)
  is
    l_frd_id  file_raw_data.frd_id%type not null:=i_frd_id;
    l_ftd_id  file_text_data.ftd_id%type;
    l_fmd_row file_meta_data%rowtype;
    l_frd_row file_raw_data%rowtype;
    l_sql     varchar2(1000 char);
  begin
    
    select *
      into l_frd_row
      from file_raw_data
     where frd_id=l_frd_id;
    o_filename:=l_frd_row.filename;
    o_filesize:=l_frd_row.filesize;
    
    select *
      into l_fmd_row
      from file_meta_data
     where l_frd_row.filename like case when filter_is_regular_expression=0 
                                    then replace(filename_match_filter, '*', '%')
                                    else l_frd_row.filename
                                   end
       and regexp_like(l_frd_row.filename, case when filter_is_regular_expression=1 
                                            then filename_match_filter 
                                            else l_frd_row.filename
                                           end);
    o_fmd_id:=l_fmd_row.fmd_id;
    o_fad_id:=l_fmd_row.fad_id;

    l_ftd_id := file_text_data_seq.nextval;    
    l_sql:='begin imp_'||l_fmd_row.fad_id||'_file_adapter_data'||
           '.insert_file_text_data(:1, :2, :3, :4, :5, :6); end;';
    execute immediate l_sql using l_frd_row.frd_id,
                                  l_fmd_row.fmd_id,
                                  l_ftd_id,
                                  l_frd_row.blob_value,
                                  l_fmd_row.ora_charset_id,
                                  l_fmd_row.ora_charset_name;
    o_ftd_id:=l_ftd_id;

  exception when no_data_found then
    o_ftd_id:=null;
  end insert_rows;
--------------------------------------------------------------------------------
  procedure delete_rows (
    i_ftd_id in file_text_data.ftd_id%type)
  is
    l_ftd_id file_text_data.ftd_id%type not null:=i_ftd_id;
  begin
    delete file_text_data
     where ftd_id=l_ftd_id;
    commit;
  end delete_rows;
--------------------------------------------------------------------------------
end file_text_data_api;
/