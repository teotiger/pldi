create or replace package body file_text_data_api_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_filename constant file_raw_data.filename%type:='samplefile.txt';
  c_filedata constant varchar2(30 char):='Hello;World';
  c_keyword constant varchar2(30 char):='$?#*~';
  c_description_text constant varchar2(30 char):='Lorem Ipsum...';
  c_fad_id constant number:=1;
  c_utf8 constant varchar2(4 char):='UTF8';
  c_semicolon constant varchar2(1 char):=';';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure insert_rows_example is
    l_ftd_id file_text_data.ftd_id%type;
    l_tmp number;
    l_cnt number;
  begin
    file_meta_data_api.insert_row(
      i_fad_id => c_fad_id,
      i_filename_match_filter => c_filename,
      i_filter_is_regular_expression => 0,
      i_ora_charset_name => c_utf8,
      i_delimiter => c_semicolon,
      i_enclosure => null,
      i_plsql_after_processing => null,
      i_keyword => c_keyword,
      i_description_text => c_description_text);

    file_text_data_api.insert_rows(
      i_frd_id => file_raw_data_api.insert_row(
        i_filename => c_filename,
        i_blob_value => sys.utl_raw.cast_to_raw(c_filedata)
      ),
      o_ftd_id => l_ftd_id,
      o_fmd_id => l_tmp,
      o_fad_id => l_tmp);

    select count(*)
      into l_cnt
      from file_text_data
     where ftd_id=l_ftd_id;

    ut.expect( l_cnt ).to_be_greater_than( 0 );

  end insert_rows_example;
--------------------------------------------------------------------------------
  procedure delete_rows_example is
    l_ftd_id file_text_data.ftd_id%type;
    l_tmp number;
    l_cnt number;
  begin
    file_meta_data_api.insert_row(
      i_fad_id => c_fad_id,
      i_filename_match_filter => c_filename,
      i_filter_is_regular_expression => 0,
      i_ora_charset_name => c_utf8,
      i_delimiter => c_semicolon,
      i_enclosure => null,
      i_plsql_after_processing => null,
      i_keyword => c_keyword,
      i_description_text => c_description_text);

    file_text_data_api.insert_rows(
      i_frd_id => file_raw_data_api.insert_row(
        i_filename => c_filename,
        i_blob_value => sys.utl_raw.cast_to_raw(c_filedata)
      ),
      o_ftd_id => l_ftd_id,
      o_fmd_id => l_tmp,
      o_fad_id => l_tmp);

    file_text_data_api.delete_rows(i_ftd_id => l_ftd_id);

    select count(*)
      into l_cnt
      from file_text_data
     where ftd_id=l_ftd_id;

    ut.expect( l_cnt ).to_equal( 0 );

  end delete_rows_example;
--------------------------------------------------------------------------------
end file_text_data_api_ut;
/
