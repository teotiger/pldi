create or replace view file_content_v
as
  select 
    --sheet_id,
    --sheet_name,
    row_number,
    c001,
    c002,
    c003,
    c004,
    c005,
    c006,
    c007,
    c008,
    c009,
    c010,
    frd.filename,
    ftd.timestamp_insert,
    frd_id
  from
    file_text_data ftd
    join file_raw_data frd using ( frd_id )
;