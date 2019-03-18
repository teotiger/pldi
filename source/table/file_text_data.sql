create table file_text_data (
  ftd_id             number(10, 0),
  frd_id             number(10, 0),
  fmd_id             number(5, 0),
  timestamp_insert   timestamp not null,
  sheet_id           number(2, 0),
  sheet_name         varchar2(255 char),
  row_number         number(8, 0) not null,
  c001               varchar2(4000 char),
  c002               varchar2(4000 char),
  c003               varchar2(4000 char),
  c004               varchar2(4000 char),
  c005               varchar2(4000 char),
  c006               varchar2(4000 char),
  c007               varchar2(4000 char),
  c008               varchar2(4000 char),
  c009               varchar2(4000 char),
  c010               varchar2(4000 char),
  -- combined PK?!?                                                             -- TODO
  constraint file_text_data_frd_id_fk foreign key ( frd_id )
    references file_raw_data ( frd_id ),
  constraint file_text_data_fmd_id_fk foreign key ( fmd_id )
    references file_meta_data ( fmd_id )
);
-------
create sequence file_text_data_seq 
  minvalue 1 start with 1 increment by 1 cache 8;
create index file_text_data_ftd_id_idx on file_text_data (ftd_id);
