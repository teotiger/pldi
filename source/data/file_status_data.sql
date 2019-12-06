create table file_status_data (
  fsd_id            number(10, 0),
  frd_id            number(10, 0),
  fmd_id            number(5, 0),
  fad_id            number(2, 0),
  ftd_id            number(10, 0),
  filename          varchar2(255 char) not null,
  seconds_1         number,
  seconds_2         number,
  seconds_3         number,
  seconds_4         number,
  seconds_total     number as (nvl(seconds_1,0)+nvl(seconds_2,0)+nvl(seconds_3,0)+nvl(seconds_4,0)) virtual,
  error_message     varchar2(4000 char),
  timestamp_insert  timestamp default systimestamp not null,
  username_insert   varchar2(255 char) not null,
  timestamp_update  timestamp default systimestamp not null,
  username_update   varchar2(255 char) not null,
  constraint file_status_data_pk primary key ( fsd_id )
);
---
create sequence file_status_data_seq 
  minvalue 1 start with 1 increment by 1 nocache;
