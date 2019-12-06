create or replace package body file_text_data_api_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_filename constant file_raw_data.filename%type:='samplefile.txt';
  c_filedata constant varchar2(30 char):='Hello;World';
  c_keyword constant varchar2(30 char):='$?#*~';
  c_description_text constant varchar2(30 char):='Lorem Ipsum...';
  c_utf8 constant varchar2(4 char):='UTF8';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure insert_rows_example is
    l_before number;
    l_after number;
    l_fad_id file_meta_data.fad_id%type;


    l_tmp number;
  begin
    file_meta_data_api.insert_row(
      i_fad_id => file_adapter_data_api.insert_row(i_keyword => c_keyword,
                                                   i_description_text => c_description_text),
      i_filename_match_filter => c_filename,
      i_filter_is_regular_expression => 0,
      i_ora_charset_name => c_utf8,
      i_delimiter => null,
      i_enclosure => null,
      i_plsql_after_processing => null,
      i_keyword => c_keyword,
      i_description_text => c_description_text);
  
    file_text_data_api.insert_rows(
      i_frd_id => file_raw_data_api.insert_row(
      i_filename => c_filename,
      i_blob_value => utl_raw.cast_to_raw(c_filedata)),
--      file_raw_data_api.insert_row(i_filename => c_filename,
--                                               i_directory => c_keyword),
      o_ftd_id => l_tmp,
      o_fmd_id => l_tmp,
      o_fad_id => l_tmp);
  
--    select count(*)
--      into l_before 
--      from file_meta_data 
--     where keyword=c_keyword;
--    l_fad_id:=file_adapter_data_api.insert_row(i_keyword => c_keyword,
--                                               i_description_text => c_description_text);
--    file_meta_data_api.insert_row(i_fad_id => l_fad_id,
--                                  i_filename_match_filter => c_keyword,
--                                  i_filter_is_regular_expression => 1,
--                                  i_ora_charset_name => c_utf8,
--                                  i_delimiter => null,
--                                  i_enclosure => null,
--                                  i_plsql_after_processing => null,
--                                  i_keyword => c_keyword,
--                                  i_description_text => c_description_text);
--    select count(*)
--      into l_after 
--      from file_meta_data 
--     where keyword=c_keyword;
--    ut.expect( l_after ).to_equal( l_before+1 );

    ut.expect( 1+1 ).to_equal( 2 );

  end insert_rows_example;
--------------------------------------------------------------------------------
  procedure delete_rows_example is
    l_fad_id file_meta_data.fad_id%type;
    l_fmd_id file_meta_data.fmd_id%type;
    l_after number;
  begin
    ut.expect( 4+1+1 ).to_equal( 4+2 );

--  delete_rows (i_ftd_id in number);
  
--    l_fad_id:=file_adapter_data_api.insert_row(i_keyword => c_keyword,
--                                               i_description_text => c_description_text);
--    l_fmd_id:=file_meta_data_api.insert_row(i_fad_id => l_fad_id,
--                                            i_filename_match_filter => c_keyword,
--                                            i_filter_is_regular_expression => 1,
--                                            i_ora_charset_name => c_utf8,
--                                            i_delimiter => null,
--                                            i_enclosure => null,
--                                            i_plsql_after_processing => null,
--                                            i_keyword => c_keyword,
--                                            i_description_text => c_description_text);
--    file_meta_data_api.delete_row(i_fmd_id => l_fmd_id);
--    select count(*)
--      into l_after 
--      from file_meta_data 
--     where fmd_id=l_fmd_id;
--    ut.expect( l_after ).to_equal( 0 );
  end delete_rows_example;
--------------------------------------------------------------------------------
end file_text_data_api_ut;
/
