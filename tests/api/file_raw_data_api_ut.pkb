create or replace package body file_raw_data_api_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_filename constant file_raw_data.filename%type:='samplefile.txt';
  c_filedata constant varchar2(30 char):='Hello;World';
  c_temp_txt constant varchar2(30 char):='$?#*~';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure insert_row_from_string is
    l_before number;
    l_after number;
  begin
    select count(*)
      into l_before 
      from file_raw_data 
     where filename=c_filename;
    file_raw_data_api.insert_row(
      i_filename => c_filename,
      i_blob_value => utl_raw.cast_to_raw(c_filedata));
    select count(*)
      into l_after 
      from file_raw_data 
     where filename=c_filename;
    ut.expect( l_after ).to_equal( l_before+1 );
  end insert_row_from_string;
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_dir is
  begin
    file_raw_data_api.insert_row(i_filename => c_filename,
                                 i_directory => c_temp_txt);
  end insert_file_non_existing_dir;
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_file is
  begin
    file_raw_data_api.insert_row(i_filename => c_temp_txt);
  end insert_file_non_existing_file;
--------------------------------------------------------------------------------
  procedure delete_row is
    l_frd_id file_raw_data.frd_id%type;
    l_after number;
  begin
    l_frd_id:=file_raw_data_api.insert_row(
      i_filename => c_filename,
      i_blob_value => utl_raw.cast_to_raw(c_filedata));
    file_raw_data_api.delete_row(i_frd_id => l_frd_id);
    select count(*)
      into l_after 
      from file_raw_data 
     where filename=c_filename;
    ut.expect( l_after ).to_equal( 0 );
  end delete_row;
--------------------------------------------------------------------------------
end file_raw_data_api_ut;
/
