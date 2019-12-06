create table file_adapter_data (
  fad_id            number(2, 0),
  keyword           varchar2(64 char) not null,
  description_text  varchar2(255 char) not null,
  timestamp_insert  timestamp default systimestamp not null,
  username_insert   varchar2(255 char) not null,
  timestamp_update  timestamp default systimestamp not null,
  username_update   varchar2(255 char) not null,
  constraint file_adapter_data_pk primary key ( fad_id )
);
---
create sequence file_adapter_data_seq 
  minvalue 1 start with 1 increment by 1 nocache;