create or replace package body file_adapter_data_api_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_keyword constant varchar2(30 char):='$?#*~';
  c_description_text constant varchar2(30 char):='Lorem Ipsum...';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure insert_row_example is
    l_before number;
    l_after number;
  begin
    select count(*)
      into l_before 
      from file_adapter_data 
     where keyword=c_keyword;
    file_adapter_data_api.insert_row(i_keyword => c_keyword,
                                     i_description_text => c_description_text);
    select count(*)
      into l_after 
      from file_adapter_data 
     where keyword=c_keyword;
    ut.expect( l_after ).to_equal( l_before+1 );
  end insert_row_example;
--------------------------------------------------------------------------------
  procedure update_row_example is
    l_fad_id file_adapter_data.fad_id%type;
    l_after varchar2(4000 char);
  begin
    l_fad_id:=file_adapter_data_api.insert_row(i_keyword => c_description_text,
                                               i_description_text => c_keyword);
    file_adapter_data_api.update_row(i_fad_id => l_fad_id, 
                                     i_keyword => c_keyword,
                                     i_description_text => c_description_text);
    select keyword||description_text
      into l_after
      from file_adapter_data
     where fad_id=l_fad_id;
    ut.expect( l_after ).to_equal( c_keyword||c_description_text );
  end update_row_example;
--------------------------------------------------------------------------------
  procedure delete_row_example is
    l_fad_id file_adapter_data.fad_id%type;
    l_after number;
  begin
    l_fad_id:=file_adapter_data_api.insert_row(i_keyword => c_keyword,
                                               i_description_text => c_description_text);
    file_adapter_data_api.delete_row(i_fad_id => l_fad_id);
    select count(*)
      into l_after 
      from file_adapter_data 
     where fad_id=l_fad_id;
    ut.expect( l_after ).to_equal( 0 );
  end delete_row_example;
--------------------------------------------------------------------------------
end file_adapter_data_api_ut;
/
