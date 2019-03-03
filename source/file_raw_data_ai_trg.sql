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

  -- wie dynamisch?
  case l_fmd_row.fad_id
    when 1 then di_file_adapter1.insert_file_text_data(:new.frd_id, l_fmd_row);
    when 2 then di_file_adapter2.insert_file_text_data(:new.frd_id, l_fmd_row);
  end case;
  
exception 
  when no_data_found then null;
  when others then raise;
end file_raw_data_ai_trg;
