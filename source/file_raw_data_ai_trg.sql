create or replace trigger di.file_raw_data_ai_trg after
  insert on di.file_raw_data
  for each row
declare
  l_fmd_row file_meta_data%rowtype;
  l_sql varchar2(255 char);
begin
  
  select *
    into l_fmd_row
    from file_meta_data fmd 
   where :new.filename like replace(fmd.filename_match, '*', '%');              -- TODO regexp!

dbms_output.put_line(:new.frd_id ||'-'||dbms_lob.getlength(:new.blob_value)||'-'||l_fmd_row.fmd_id || l_fmd_row.character_set);

  l_sql:='begin di_file_adapter'||l_fmd_row.fad_id||'.insert_file_text_data(:0, :1, :2); end;';
  execute immediate l_sql using :new.frd_id, :new.blob_value,l_fmd_row.fmd_id, l_fmd_row.character_set;
  
exception 
  when no_data_found then null;
  when others then raise;
end file_raw_data_ai_trg;
