create table file_meta_data (
  fmd_id                        number(5, 0),
  timestamp_insert              timestamp default systimestamp not null,
  timestamp_update              timestamp default systimestamp not null,
  username_insert               varchar2(30 char) default sys_context('userenv','os_user') not null,
  username_update               varchar2(30 char) default sys_context('userenv','os_user') not null,
  keyword                       varchar2(64 char) not null,
  filename_match_filter         varchar2(255 char) not null,
  filter_is_regular_expression  number(1,0) default 0 not null,  
  fad_id                        number(2, 0) not null,
  ora_charset_name              varchar2(16 char) not null,
  ora_charset_id                number as ( nls_charset_id( ora_charset_name ) ) virtual,
  delimiter                     varchar2(1 char),
  enclosure                     varchar2(1 char),
  plsql_after_processing        varchar2(4000 char),
  constraint file_meta_data_pk primary key ( fmd_id ),
  constraint file_meta_data_fad_id_fk foreign key ( fad_id )
    references file_adapter_data ( fad_id )
);
------
comment on column file_meta_data.keyword is
  'A keyword or short description text.';
comment on column file_meta_data.filename_match_filter is
  'The pattern which has to match the filename. This can be a simple pattern with wildcards (use asterisk "*") or a complex regular expression pattern.';
comment on column file_meta_data.filter_is_regular_expression is
  'If the value in FILENAME_MATCH_FILTER is a regular expression then 1, else 0 (default).';
comment on column file_meta_data.ora_charset_name is
  'An Oracle character set name.';
comment on column file_meta_data.ora_charset_id is
  'The corresponding ID for ORA_CHARSET_NAME';
comment on column file_meta_data.delimiter is
  'The field delimiter (one character only).';
comment on column file_meta_data.enclosure is
  'The field enclosure character (one character only).';
comment on column file_meta_data.plsql_after_processing is
  'The PLSQL code to execute after the successful data extraction.';
------
create sequence file_meta_data_seq 
  minvalue 1 start with 1 increment by 1 nocache;