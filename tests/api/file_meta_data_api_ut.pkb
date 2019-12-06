create or replace package body file_meta_data_api_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_keyword constant varchar2(30 char):='$?#*~';
  c_description_text constant varchar2(30 char):='Lorem Ipsum...';
  c_utf8 constant varchar2(4 char):='UTF8';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure insert_row_example is
    l_before number;
    l_after number;
    l_fad_id file_meta_data.fad_id%type;
  begin
    select count(*)
      into l_before 
      from file_meta_data 
     where keyword=c_keyword;
    l_fad_id:=file_adapter_data_api.insert_row(i_keyword => c_keyword,
                                               i_description_text => c_description_text);
    file_meta_data_api.insert_row(i_fad_id => l_fad_id,
                                  i_filename_match_filter => c_keyword,
                                  i_filter_is_regular_expression => 1,
                                  i_ora_charset_name => c_utf8,
                                  i_delimiter => null,
                                  i_enclosure => null,
                                  i_plsql_after_processing => null,
                                  i_keyword => c_keyword,
                                  i_description_text => c_description_text);
    select count(*)
      into l_after 
      from file_meta_data 
     where keyword=c_keyword;
    ut.expect( l_after ).to_equal( l_before+1 );
  end insert_row_example;
--------------------------------------------------------------------------------
  procedure update_row_example is
    l_fad_id file_meta_data.fad_id%type;
    l_fmd_id file_meta_data.fmd_id%type;
    l_after file_meta_data.fmd_id_is_inactive%type;
  begin
    l_fad_id:=file_adapter_data_api.insert_row(i_keyword => c_keyword,
                                               i_description_text => c_description_text);
    l_fmd_id:=file_meta_data_api.insert_row(i_fad_id => l_fad_id,
                                            i_filename_match_filter => c_keyword,
                                            i_filter_is_regular_expression => 1,
                                            i_ora_charset_name => c_utf8,
                                            i_delimiter => null,
                                            i_enclosure => null,
                                            i_plsql_after_processing => null,
                                            i_keyword => c_keyword,
                                            i_description_text => c_description_text);
    file_meta_data_api.update_row(i_fmd_id => l_fmd_id, 
                                  i_fmd_id_is_inactive => 1);
    select fmd_id_is_inactive
      into l_after
      from file_meta_data
     where fmd_id=l_fmd_id;
    ut.expect( l_after ).to_equal( 1 );
  end update_row_example;
--------------------------------------------------------------------------------
  procedure delete_row_example is
    l_fad_id file_meta_data.fad_id%type;
    l_fmd_id file_meta_data.fmd_id%type;
    l_after number;
  begin
    l_fad_id:=file_adapter_data_api.insert_row(i_keyword => c_keyword,
                                               i_description_text => c_description_text);
    l_fmd_id:=file_meta_data_api.insert_row(i_fad_id => l_fad_id,
                                            i_filename_match_filter => c_keyword,
                                            i_filter_is_regular_expression => 1,
                                            i_ora_charset_name => c_utf8,
                                            i_delimiter => null,
                                            i_enclosure => null,
                                            i_plsql_after_processing => null,
                                            i_keyword => c_keyword,
                                            i_description_text => c_description_text);
    file_meta_data_api.delete_row(i_fmd_id => l_fmd_id);
    select count(*)
      into l_after 
      from file_meta_data 
     where fmd_id=l_fmd_id;
    ut.expect( l_after ).to_equal( 0 );
  end delete_row_example;
--------------------------------------------------------------------------------
end file_meta_data_api_ut;
/
