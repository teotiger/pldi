create table &&pldi_user..file_adapter_data (
  fad_id            number(2, 0),
  description_text  varchar2(255 char),
  constraint file_adapter_data_pk primary key ( fad_id )
);
-------
create sequence &&pldi_user..file_adapter_data_seq 
  minvalue 1 start with 1 increment by 1;