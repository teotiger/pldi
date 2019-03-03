create table di.file_adapter_data (
  fad_id            number(2, 0),
  fad_description   varchar2(255 char),
  constraint file_adapter_data_pk primary key ( fad_id )
);
--------------------------------------------------------------------------------  
create table di.file_raw_data (
  frd_id             number(10, 0),
  timestamp_insert   timestamp not null,
  filename           varchar2(255 char) not null,
  filesize           number as (dbms_lob.getlength(blob_value)) virtual,  
  blob_value         blob not null,
  constraint file_raw_data_pk primary key ( frd_id )
);
create sequence di.file_raw_data_seq 
  minvalue 1 start with 1 increment by 1 cache 8;
--------------------------------------------------------------------------------  
create table di.file_meta_data (
  fmd_id                 number(5, 0),
  timestamp_insert       timestamp not null,
  timestamp_update       timestamp not null,
  username_insert        varchar2(30 char) not null,
  username_update        varchar2(30 char) not null,
  keyword                varchar2(64 char) not null,
  filename_match         varchar2(255 char) not null,                           -- regexp
  fad_id                 number(2, 0),
  character_encoding     varchar2(8 char) not null,
  delimiter              varchar2(1 char),
  enclosure              varchar2(1 char),
  constraint file_meta_data_pk primary key ( fmd_id ),
  constraint file_meta_data_fad_id_fk foreign key ( fad_id )
    references di.file_adapter_data ( fad_id )
);
-------
comment on column di.file_meta_data.delimiter is
  'The field delimiter (one character only).';
comment on column di.file_meta_data.enclosure is
  'The field enclosure character (one character only).';
-------
create sequence di.file_meta_data_seq 
  minvalue 1 start with 1 increment by 1 nocache;
--------------------------------------------------------------------------------  
create table di.file_text_data (
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
  constraint file_text_data_frd_id_fk foreign key ( frd_id )
    references di.file_raw_data ( frd_id ),
  constraint file_text_data_fmd_id_fk foreign key ( fmd_id )
    references di.file_meta_data ( fmd_id )
);