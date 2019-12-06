create table file_raw_data (
  frd_id             number(10, 0),
  timestamp_insert   timestamp default systimestamp not null,
  filename           varchar2(255 char) not null,
  filesize           number as ( dbms_lob.getlength(blob_value) ) virtual,  
  blob_value         blob not null,
  constraint file_raw_data_pk primary key ( frd_id )
)
  lob (blob_value) 
    store as file_raw_data_blob_value (index file_raw_data_blob_value_idx)
;
------
create sequence file_raw_data_seq 
  minvalue 1 start with 1 increment by 1 cache 8;