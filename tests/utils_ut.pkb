create or replace package body utils_ut as
--------------------------------------------------------------------------------
  procedure version_check is
    c_regexp constant varchar2(32 char):='^v[0-9]{1}\.[0-9]{1,}.[0-9]{1,}$';
    l_expected number;
  begin
    select count(*) 
      into l_expected
      from dual
     where regexp_like (utils.version, c_regexp);
    ut.expect( l_expected ).to_equal( 1 );
  end version_check;
--------------------------------------------------------------------------------
  procedure version_is_not_a_number is
    l_number number;
  begin
    l_number:=utils.version;
  end version_is_not_a_number;
--------------------------------------------------------------------------------
  procedure username_check is
    l_expected number;
  begin
    select count(*)
      into l_expected
      from dual
     where regexp_like (utils.username, '[A-Za-z]+');
    ut.expect( l_expected ).to_equal( 1 );
  end username_check;
--------------------------------------------------------------------------------
  procedure mimetype_csv is
    c_filename constant file_raw_data.filename%type:='abc.xyz';
    c_result constant file_raw_data.mimetype%type:='application/octet-stream';
  begin
    ut.expect( utils.mimetype(i_filename => c_filename) ).to_equal( c_result );
  end mimetype_csv;
--------------------------------------------------------------------------------
  procedure mimetype_unknown is
    c_filename constant file_raw_data.filename%type:='some_data.csv';
    c_result constant file_raw_data.mimetype%type:='text/csv';
  begin
    ut.expect( utils.mimetype(i_filename => c_filename) ).to_equal( c_result );
  end mimetype_unknown;
--------------------------------------------------------------------------------
  procedure directory_setting_is_correct is
    l_directory_exists_fl number;
  begin
    select count(*)
      into l_directory_exists_fl
      from all_directories
     where directory_name=utils.directory_setting;
    ut.expect( l_directory_exists_fl ).to_equal( 1 );
  end directory_setting_is_correct;
--------------------------------------------------------------------------------
  procedure max_bytes_setting_is_correct is
  begin
    ut.expect( utils.max_bytes_setting ).to_be_greater_than( 1 );
  end max_bytes_setting_is_correct;
--------------------------------------------------------------------------------
end utils_ut;
/
