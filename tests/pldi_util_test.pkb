create or replace package body &&pldi_user..pldi_util_test as
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_dir is
  begin
    ut.expect( pldi_util.insert_file_raw_data('samplefile.txt', '$?#*~') ).to_( equal(1) );
  end insert_file_non_existing_dir;
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_file is
  begin
    ut.expect( pldi_util.insert_file_raw_data('$?#*~') ).to_( equal(2) );
  end insert_file_non_existing_file;
--------------------------------------------------------------------------------
end pldi_util_test;
/
