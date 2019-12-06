create or replace package body file_status_data_api_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_filename constant file_status_data.filename%type:='sample_xyz_file.txt';
  c_filedata constant varchar2(30 char):='Hello;World';
  c_temp_txt constant varchar2(30 char):='$?#*~';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure insert_row_with_filename is
    l_before number;
    l_after number;
  begin
    select count(*)
      into l_before 
      from file_status_data 
     where filename=c_filename;
    file_status_data_api.insert_row(i_filename => c_filename);
    select count(*)
      into l_after 
      from file_status_data 
     where filename=c_filename;
    ut.expect( l_after ).to_equal( l_before+1 );
  end insert_row_with_filename;
--------------------------------------------------------------------------------
  procedure update_row_with_info_1 is
    l_fsd_id file_status_data.fsd_id%type;
    l_after number;
  begin
    l_fsd_id:=file_status_data_api.insert_row(i_filename => c_filename);
    file_status_data_api.update_row(i_fsd_id => l_fsd_id, 
                                    i_frd_id => -1,
                                    i_seconds_1 => 1+1);
    select frd_id+seconds_1
      into l_after
      from file_status_data
     where fsd_id=l_fsd_id;
    ut.expect( l_after ).to_equal( 1 );
  end update_row_with_info_1;
--------------------------------------------------------------------------------
  procedure update_row_with_info_2 is
    l_fsd_id file_status_data.fsd_id%type;
    l_after number;
  begin
    l_fsd_id:=file_status_data_api.insert_row(i_filename => c_filename);
    file_status_data_api.update_row(i_fsd_id => l_fsd_id, 
                                    i_ftd_id => -1,
                                    i_fmd_id => -1,
                                    i_fad_id => -1,
                                    i_seconds_2 => 1+2);
    select ftd_id+seconds_2
      into l_after
      from file_status_data
     where fsd_id=l_fsd_id;
    ut.expect( l_after ).to_equal( 2 );
  end update_row_with_info_2;
--------------------------------------------------------------------------------
  procedure update_row_with_info_3 is
    l_fsd_id file_status_data.fsd_id%type;
    l_after number;
  begin
    l_fsd_id:=file_status_data_api.insert_row(i_filename => c_filename);
    file_status_data_api.update_row(i_fsd_id => l_fsd_id, 
                                    i_frd_id => -1,
                                    i_seconds_3 => 1+3);
    select frd_id+seconds_3
      into l_after
      from file_status_data
     where fsd_id=l_fsd_id;
    ut.expect( l_after ).to_equal( 3 );
  end update_row_with_info_3;
--------------------------------------------------------------------------------
  procedure update_row_with_info_4 is
    l_fsd_id file_status_data.fsd_id%type;
    l_after number;
  begin
    l_fsd_id:=file_status_data_api.insert_row(i_filename => c_filename);
    file_status_data_api.update_row(i_fsd_id => l_fsd_id, 
                                    i_frd_id => -1,
                                    i_seconds_4 => 1+4);
    select frd_id+seconds_4
      into l_after
      from file_status_data
     where fsd_id=l_fsd_id;
    ut.expect( l_after ).to_equal( 4 );
  end update_row_with_info_4;
--------------------------------------------------------------------------------
  procedure update_row_with_error_message is
    l_fsd_id file_status_data.fsd_id%type;
    l_after file_status_data.error_message%type;
  begin
    l_fsd_id:=file_status_data_api.insert_row(i_filename => c_filename);
    file_status_data_api.update_row(i_fsd_id => l_fsd_id, 
                                    i_error_message => c_temp_txt);
    select error_message
      into l_after
      from file_status_data
     where fsd_id=l_fsd_id;
    ut.expect( l_after ).to_equal( c_temp_txt );
  end update_row_with_error_message;
--------------------------------------------------------------------------------
  procedure delete_row is
    l_fsd_id file_status_data.fsd_id%type;
    l_after number;
  begin
    l_fsd_id:=file_status_data_api.insert_row(i_filename => c_filename);
    file_status_data_api.delete_row(i_fsd_id => l_fsd_id);
    select count(*)
      into l_after 
      from file_status_data 
     where fsd_id=l_fsd_id;
    ut.expect( l_after ).to_equal( 0 );
  end delete_row;
--------------------------------------------------------------------------------
  procedure global_cleanup is
  begin
    file_status_data_api.delete_rows(i_filename => c_filename);
  end global_cleanup;
--------------------------------------------------------------------------------
end file_status_data_api_ut;
/
