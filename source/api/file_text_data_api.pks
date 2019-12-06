create or replace package file_text_data_api authid definer 
as

  -- Add a new row to FILE_TEXT_DATA and return FTD_ID, FMD_ID and FAD_ID.
  procedure insert_rows (
    i_frd_id in  number,
    o_ftd_id out number,
    o_fmd_id out number,
    o_fad_id out number
  );

  -- Remove any row from FILE_TEXT_DATA where the FTD_ID match.
  procedure delete_rows (i_ftd_id in number);

end file_text_data_api;
/