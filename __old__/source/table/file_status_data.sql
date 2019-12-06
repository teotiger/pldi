create table file_status_data (
  fsd_id            number(10, 0),
  timestamp_insert  timestamp default systimestamp not null,
  timestamp_update  timestamp default systimestamp not null,
  username_insert   varchar2(30 char) default sys_context('userenv','os_user') not null,
  username_update   varchar2(30 char) default sys_context('userenv','os_user') not null,
  frd_id            number(10, 0) not null,
  fmd_id            number(5, 0),
  fad_id            number(2, 0),
  ftd_id            number(10, 0),
  filename          varchar2(255 char) not null,
  filesize          number not null,
  seconds_step1     number not null,
  seconds_step2     number,
  seconds_step3     number,
  seconds_total     number as (seconds_step1+seconds_step2+seconds_step3) virtual,
-- PROBLEM => create table BEFORE package code
--  time_total        varchar2(4000 char) as (utils.format_seconds(seconds_step1+seconds_step2+seconds_step3)) virtual,
  error_message     varchar2(4000 char),
  constraint file_status_data_pk primary key ( fsd_id ),
  constraint file_status_data_frd_id_fk foreign key ( frd_id )
    references file_raw_data ( frd_id )
);
------
create sequence file_status_data_seq 
  minvalue 1 start with 1 increment by 1 nocache;