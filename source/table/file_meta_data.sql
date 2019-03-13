create table file_meta_data (
  fmd_id                      number(5, 0),
  timestamp_insert            timestamp default systimestamp not null,
  timestamp_update            timestamp default systimestamp not null,
  username_insert             varchar2(30 char) default sys_context('userenv','os_user') not null,
  username_update             varchar2(30 char) default sys_context('userenv','os_user') not null,
  keyword                     varchar2(64 char) not null,
  filename_match_like         varchar2(255 char) not null,
  filename_match_regexp_like  varchar2(255 char),
  fad_id                      number(2, 0),
  character_set               varchar2(8 char) not null,
  ora_charset_id              number as (nls_charset_id(replace(character_set,'-',''))) virtual,
  delimiter                   varchar2(1 char),
  enclosure                   varchar2(1 char),
  plsql_after_processing      varchar2(4000 char),
  constraint file_meta_data_pk primary key ( fmd_id ),
  constraint file_meta_data_fad_id_fk foreign key ( fad_id )
    references file_adapter_data ( fad_id )
);
-------
comment on column file_meta_data.filename_match_like is
  'The pattern which has to match the filename. The only allowed wildcard is the asterisk (*). It will be replaced by ''%'' during SQL execution.';
comment on column file_meta_data.filename_match_regexp_like is
  'The regular expression which has to match the filename.';
comment on column file_meta_data.delimiter is
  'The field delimiter (one character only).';
comment on column file_meta_data.enclosure is
  'The field enclosure character (one character only).';
comment on column file_meta_data.plsql_after_processing is
  'The PLSQL code to execute after the successful data extraction.';
-------
create sequence file_meta_data_seq 
  minvalue 1 start with 1 increment by 1 nocache;