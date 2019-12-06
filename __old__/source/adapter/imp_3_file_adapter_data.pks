create or replace package imp_3_file_adapter_data authid definer 
as

/*
  DIFF adapter 2 <--> 3
  
  select FRD_ID ,FMD_ID ,SHEET_ID ,SHEET_NAME ,ROW_NUMBER ,C001 ,C002 ,C003 ,C004 ,C005 ,C006 ,C007 ,C008 ,C009 ,C010 ,C011 ,C012 ,C013 ,C014 ,C015 ,C016 
  from file_text_data_ref where frd_id=6 and row_number=2
--minus
union all
select FRD_ID ,FMD_ID ,SHEET_ID ,SHEET_NAME ,ROW_NUMBER ,C001 ,C002 ,C003 ,C004 ,C005 ,C006 ,C007 ,C008 ,C009 ,C010 ,C011 ,C012 ,C013 ,C014 ,C015 ,C016 
  from file_text_data where frd_id=6 and row_number=2
;

  https://github.com/OraOpenSource/oos-utils/files/1497585/as_read_xlsx10_clean.txt

*/

  -- This procedure try to extract the binary data to structured tabular data.
  -- @The file-raw-data-ID (primary key from FILE_RAW_DATA table).
  -- @The file-meta-data-ID (primary key from FILE_META_DATA table).
  -- @The file-text-data-ID from FILE_TEXT_DATA table.
  -- @The binary large object.
  -- @The Oracle character set id to encode the file.
  -- @The Oracle character set name to encode the file.
  procedure insert_file_text_data(
    i_frd_id            in file_raw_data.frd_id%type,
    i_fmd_id            in file_meta_data.fmd_id%type,
    i_ftd_id            in file_text_data.ftd_id%type,
    i_blob_value        in file_raw_data.blob_value%type,
    i_ora_charset_id    in file_meta_data.ora_charset_id%type,
    i_ora_charset_name  in file_meta_data.ora_charset_name%type);

end imp_3_file_adapter_data;
/