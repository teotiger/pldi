create or replace package body file_meta_data_api_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_fmd_id constant file_meta_data.fmd_id%type:=-1;
  c_keyword constant file_meta_data.keyword%type:='FooBar';
  g_frd_id file_raw_data.frd_id%type;
--------------------------------------------------------------------------------
  procedure setup is
    c_filename constant file_raw_data.filename%type:='foobar.csv';
    c_filename_match_filter constant file_meta_data.filename_match_filter%type:='*.*';
    c_ora_charset_name constant file_meta_data.ora_charset_name%type:='UTF8';
  begin
    insert into file_raw_data (
      frd_id,
      filename,
      blob_value
    ) values (
      file_raw_data_seq.nextval,
      c_filename,
      empty_blob()
    ) returning frd_id into g_frd_id;

    insert into file_meta_data (
      fmd_id,
      keyword,
      filename_match_filter,
      filter_is_regular_expression,
      fad_id,
      ora_charset_name
    ) values (
      c_fmd_id,
      c_keyword,
      c_filename_match_filter,
      0,
      1,
      c_ora_charset_name
    );
  
    insert into file_text_data (
      ftd_id,
      frd_id,
      fmd_id,
      timestamp_insert,
      row_number
    ) values (
      file_text_data_seq.nextval,
      g_frd_id,
      c_fmd_id,
      sysdate,
      1
    );
    commit;
  end setup;
--------------------------------------------------------------------------------
  procedure teardown is
  begin
    delete from file_meta_data where fmd_id=c_fmd_id;
    delete from file_raw_data where frd_id=g_frd_id;
    commit;
  end teardown;
--------------------------------------------------------------------------------
  procedure update_row_single is
    c_new_keyword constant file_meta_data.keyword%type:='Works!';
    l_new_keyword file_meta_data.keyword%type;
  begin
    file_meta_data_api.update_row(i_fmd_id => c_fmd_id,
                                  i_keyword => c_new_keyword);
    select keyword
      into l_new_keyword
      from file_meta_data
     where fmd_id=c_fmd_id;
    ut.expect(l_new_keyword).to_equal(c_new_keyword);
  end update_row_single;
--------------------------------------------------------------------------------
  procedure update_row_multi is
    c_new_keyword constant file_meta_data.keyword%type:='Works!';
    c_new_fad_id constant file_meta_data.fad_id%type:=2;
    l_new_keyword file_meta_data.keyword%type;
    l_new_fad_id file_meta_data.fad_id%type;
  begin
    file_meta_data_api.update_row(i_fmd_id => c_fmd_id,
                                  i_keyword => c_new_keyword,
                                  i_fad_id => c_new_fad_id);
    select keyword, fad_id
      into l_new_keyword, l_new_fad_id
      from file_meta_data
     where fmd_id=c_fmd_id;    
    ut.expect(l_new_keyword).to_equal(c_new_keyword);
    ut.expect(l_new_fad_id).to_equal(c_new_fad_id);
  end update_row_multi;
--------------------------------------------------------------------------------
  procedure delete_row_default is
  begin
    file_meta_data_api.delete_row(i_fmd_id => c_fmd_id);
  end delete_row_default;
--------------------------------------------------------------------------------
  procedure delete_row_force is
  begin
    file_meta_data_api.delete_row(i_fmd_id => c_fmd_id,
                                  i_force_delete => true);
  end delete_row_force;
--------------------------------------------------------------------------------
end file_meta_data_api_ut;
/
