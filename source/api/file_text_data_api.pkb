create or replace package body file_text_data_api
as
--------------------------------------------------------------------------------
  procedure insert_rows (
    i_filename  in file_raw_data.filename%type)
  is
    l_filename file_raw_data.filename%type not null:=i_filename;
    l_fmd_row file_meta_data%rowtype;
    l_frd_row file_raw_data%rowtype;
    l_sql varchar2(1000 char);
  begin
  
    select *
      into l_fmd_row
      from file_meta_data fmd 
     where l_filename like replace(fmd.filename_match_like, '*', '%');        -- TODO regexp!
               
    select *
      into l_frd_row
      from file_raw_data
     where frd_id=(
      select max(frd_id)
        from file_raw_data frd 
       where filename=l_filename
           );
    
    l_sql:='begin file_adapter_data_imp_'||l_fmd_row.fad_id||
           '.insert_file_text_data(:0, :1, :2, :3); end;';
    execute immediate l_sql using l_frd_row.frd_id, l_frd_row.blob_value,
                                  l_fmd_row.fmd_id, l_fmd_row.character_set;

  end insert_rows;
--------------------------------------------------------------------------------
end file_text_data_api;
/