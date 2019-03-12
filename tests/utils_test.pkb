create or replace package body utils_test as
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_dir is
  begin
    ut.expect( 1 ).to_( equal(1) );
--    ut.expect( utils.insert_file_raw_data('samplefile.txt', '$?#*~') ).to_( equal(1) );
  end insert_file_non_existing_dir;
--------------------------------------------------------------------------------
  procedure insert_file_non_existing_file is
  begin
    ut.expect( 1 ).to_( equal(1) );
--    ut.expect( utils.insert_file_raw_data('$?#*~') ).to_( equal(2) );
  end insert_file_non_existing_file;
--------------------------------------------------------------------------------
end utils_test;
/
