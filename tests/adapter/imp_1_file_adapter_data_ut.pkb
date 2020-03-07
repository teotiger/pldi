create or replace package body imp_1_file_adapter_data_ut as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  c_filename constant file_raw_data.filename%type:='samplefile.txt';
  c_filedata constant varchar2(30 char):='Hello;World';
  c_keyword constant varchar2(30 char):='$?#*~';
  c_description_text constant varchar2(30 char):='Lorem Ipsum...';
  c_fad_id constant number:=1;
  c_utf8 constant varchar2(4 char):='UTF8';
  c_comma constant varchar2(1 char):=',';
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure complete_csv_import_w_var_cols is
    c_csv_content constant varchar2(100 char):='1,Bob,Down
2,John,Dunbar,13/06/1945
3,Alice,Wunderland';
    l_ftd_id file_text_data.ftd_id%type;
    l_tmp number;
    l_actual sys_refcursor;
    l_expected sys_refcursor;
  begin
    file_meta_data_api.insert_row(
      i_fad_id => c_fad_id,
      i_filename_match_filter => c_filename,
      i_filter_is_regular_expression => 0,
      i_ora_charset_name => c_utf8,
      i_delimiter => c_comma,
      i_enclosure => null,
      i_plsql_after_processing => null,
      i_keyword => c_keyword,
      i_description_text => c_description_text);

    file_text_data_api.insert_rows(
      i_frd_id => file_raw_data_api.insert_row(
        i_filename => c_filename,
        i_blob_value => sys.utl_raw.cast_to_raw(c_csv_content)
      ),
      o_ftd_id => l_ftd_id,
      o_fmd_id => l_tmp,
      o_fad_id => l_tmp);

    open l_actual  for 
      select c001, c002, c003, c004 
        from file_text_data 
       where ftd_id=l_ftd_id
    order by row_number;

    open l_expected for 
      select '1' as c001, 'Bob' as c002, 'Down' as c003, null as c004 from dual union
      select '2', 'John', 'Dunbar', '13/06/1945' from dual union
      select '3', 'Alice', 'Wunderland', null from dual;

    ut.expect(l_actual).to_equal(l_expected);
  end complete_csv_import_w_var_cols;
--------------------------------------------------------------------------------
  procedure remove_csv_trailing_space_eol is
    c_csv_content constant varchar2(100 char):='1,Bob,Down
2,John,Dunbar,13/06/1945
3,Alice,Wunderland
    







';
    l_ftd_id file_text_data.ftd_id%type;
    l_tmp number;
    l_actual sys_refcursor;
    l_expected sys_refcursor;
  begin
    file_meta_data_api.insert_row(
      i_fad_id => c_fad_id,
      i_filename_match_filter => c_filename,
      i_filter_is_regular_expression => 0,
      i_ora_charset_name => c_utf8,
      i_delimiter => c_comma,
      i_enclosure => null,
      i_plsql_after_processing => null,
      i_keyword => c_keyword,
      i_description_text => c_description_text);

    file_text_data_api.insert_rows(
      i_frd_id => file_raw_data_api.insert_row(
        i_filename => c_filename,
        i_blob_value => sys.utl_raw.cast_to_raw(c_csv_content)
      ),
      o_ftd_id => l_ftd_id,
      o_fmd_id => l_tmp,
      o_fad_id => l_tmp);

    open l_actual  for 
      select c001, c002, c003, c004 
        from file_text_data 
       where ftd_id=l_ftd_id
    order by row_number;

    open l_expected for 
      select '1' as c001, 'Bob' as c002, 'Down' as c003, null as c004 from dual union
      select '2', 'John', 'Dunbar', '13/06/1945' from dual union
      select '3', 'Alice', 'Wunderland', null from dual;

    ut.expect(l_actual).to_equal(l_expected);
  end remove_csv_trailing_space_eol;
--------------------------------------------------------------------------------
  procedure multiline_cell_csv_import is
    c_csv constant clob:='4;"Lа ci darem
la mano";Don
11;"Fin ch''han 
dal 
vino";Giovanni';
    c_eol constant varchar2(1 char):=chr(10);
    c_enc constant varchar2(1 char):='"';
    l_expected sys.ora_mining_varchar2_nt:=sys.ora_mining_varchar2_nt(
      '4;"Lа ci darem'||chr(10)||'la mano";Don',
      '11;"Fin ch''han 
dal 
vino";Giovanni'
    );
    l_actual sys.ora_mining_varchar2_nt;
  begin
    l_actual:=imp_1_file_adapter_data.split_vc2(
      i_string_value => c_csv,
      i_delimiter => c_eol,
      i_enclosure => c_enc,
      i_trim_enclosure => false);
    ut.expect( anydata.convertcollection(l_actual) ).to_equal(
       anydata.convertcollection(l_expected) );
  end multiline_cell_csv_import;
--------------------------------------------------------------------------------
  procedure escaping_enclosure_char is
    c_csv constant clob
      :='Piano Sonata No.17 in D minor, Op.31, No.2|Ludwig van Beethoven|"It is usually referred to as "The Tempest" (or Der Sturm in his native German)"';
    c_del constant varchar2(1 char):='|';
    c_enc constant varchar2(1 char):='"';
    l_expected sys.ora_mining_varchar2_nt:=sys.ora_mining_varchar2_nt(
      'Piano Sonata No.17 in D minor, Op.31, No.2',
      'Ludwig van Beethoven',
      'It is usually referred to as "The Tempest" (or Der Sturm in his native German)'
      );
    l_actual sys.ora_mining_varchar2_nt;    
  begin
    l_actual:=imp_1_file_adapter_data.split_vc2(
      i_string_value => c_csv,
      i_delimiter => c_del,
      i_enclosure => c_enc);
    ut.expect( anydata.convertcollection(l_actual) ).to_equal(
       anydata.convertcollection(l_expected) );
  end escaping_enclosure_char;
--------------------------------------------------------------------------------
  procedure fill_all_colums is
    l_csv varchar2(4000 char);
    l_ftd_id file_text_data.ftd_id%type;
    l_tmp number;
    l_actual sys_refcursor;
    l_expected sys_refcursor;
  begin
    with dat as (
    select rownum srt, level||chr(floor(level/8)+65) val
      from dual connect by level<=200
    )
    select listagg(val,c_comma) within group (order by srt) val
      into l_csv
      from dat;

    file_meta_data_api.insert_row(
      i_fad_id => c_fad_id,
      i_filename_match_filter => c_filename,
      i_filter_is_regular_expression => 0,
      i_ora_charset_name => c_utf8,
      i_delimiter => c_comma,
      i_enclosure => null,
      i_plsql_after_processing => null,
      i_keyword => c_keyword,
      i_description_text => c_description_text);

    file_text_data_api.insert_rows(
      i_frd_id => file_raw_data_api.insert_row(
        i_filename => c_filename,
        i_blob_value => sys.utl_raw.cast_to_raw(l_csv)
      ),
      o_ftd_id => l_ftd_id,
      o_fmd_id => l_tmp,
      o_fad_id => l_tmp);

    open l_actual  for 
      select c001, c002, c003, c004, c005, c006, c007, c008, c009, c010,
             c011, c012, c013, c014, c015, c016, c017, c018, c019, c020,
             c021, c022, c023, c024, c025, c026, c027, c028, c029, c030,
             c031, c032, c033, c034, c035, c036, c037, c038, c039, c040,
             c041, c042, c043, c044, c045, c046, c047, c048, c049, c050,
             c051, c052, c053, c054, c055, c056, c057, c058, c059, c060,
             c061, c062, c063, c064, c065, c066, c067, c068, c069, c070,
             c071, c072, c073, c074, c075, c076, c077, c078, c079, c080,
             c081, c082, c083, c084, c085, c086, c087, c088, c089, c090,
             c091, c092, c093, c094, c095, c096, c097, c098, c099, c100,
             c101, c102, c103, c104, c105, c106, c107, c108, c109, c110,
             c111, c112, c113, c114, c115, c116, c117, c118, c119, c120,
             c121, c122, c123, c124, c125, c126, c127, c128, c129, c130,
             c131, c132, c133, c134, c135, c136, c137, c138, c139, c140,
             c141, c142, c143, c144, c145, c146, c147, c148, c149, c150,
             c151, c152, c153, c154, c155, c156, c157, c158, c159, c160,
             c161, c162, c163, c164, c165, c166, c167, c168, c169, c170,
             c171, c172, c173, c174, c175, c176, c177, c178, c179, c180,
             c181, c182, c183, c184, c185, c186, c187, c188, c189, c190,
             c191, c192, c193, c194, c195, c196, c197, c198, c199, c200
        from file_text_data 
       where ftd_id=l_ftd_id
    order by row_number;

    open l_expected for 
      select 
'1A' as c001, '2A' as c002, '3A' as c003, '4A' as c004, '5A' as c005,
'6A' as c006, '7A' as c007, '8B' as c008, '9B' as c009, '10B' as c010,
'11B' as c011, '12B' as c012, '13B' as c013, '14B' as c014, '15B' as c015,
'16C' as c016, '17C' as c017, '18C' as c018, '19C' as c019, '20C' as c020,
'21C' as c021, '22C' as c022, '23C' as c023, '24D' as c024, '25D' as c025,
'26D' as c026, '27D' as c027, '28D' as c028, '29D' as c029, '30D' as c030,
'31D' as c031, '32E' as c032, '33E' as c033, '34E' as c034, '35E' as c035,
'36E' as c036, '37E' as c037, '38E' as c038, '39E' as c039, '40F' as c040,
'41F' as c041, '42F' as c042, '43F' as c043, '44F' as c044, '45F' as c045,
'46F' as c046, '47F' as c047, '48G' as c048, '49G' as c049, '50G' as c050,
'51G' as c051, '52G' as c052, '53G' as c053, '54G' as c054, '55G' as c055,
'56H' as c056, '57H' as c057, '58H' as c058, '59H' as c059, '60H' as c060,
'61H' as c061, '62H' as c062, '63H' as c063, '64I' as c064, '65I' as c065,
'66I' as c066, '67I' as c067, '68I' as c068, '69I' as c069, '70I' as c070,
'71I' as c071, '72J' as c072, '73J' as c073, '74J' as c074, '75J' as c075,
'76J' as c076, '77J' as c077, '78J' as c078, '79J' as c079, '80K' as c080,
'81K' as c081, '82K' as c082, '83K' as c083, '84K' as c084, '85K' as c085,
'86K' as c086, '87K' as c087, '88L' as c088, '89L' as c089, '90L' as c090,
'91L' as c091, '92L' as c092, '93L' as c093, '94L' as c094, '95L' as c095,
'96M' as c096, '97M' as c097, '98M' as c098, '99M' as c099, '100M' as c100,
'101M' as c101, '102M' as c102, '103M' as c103, '104N' as c104, '105N' as c105,
'106N' as c106, '107N' as c107, '108N' as c108, '109N' as c109, '110N' as c110,
'111N' as c111, '112O' as c112, '113O' as c113, '114O' as c114, '115O' as c115,
'116O' as c116, '117O' as c117, '118O' as c118, '119O' as c119, '120P' as c120,
'121P' as c121, '122P' as c122, '123P' as c123, '124P' as c124, '125P' as c125,
'126P' as c126, '127P' as c127, '128Q' as c128, '129Q' as c129, '130Q' as c130,
'131Q' as c131, '132Q' as c132, '133Q' as c133, '134Q' as c134, '135Q' as c135,
'136R' as c136, '137R' as c137, '138R' as c138, '139R' as c139, '140R' as c140,
'141R' as c141, '142R' as c142, '143R' as c143, '144S' as c144, '145S' as c145,
'146S' as c146, '147S' as c147, '148S' as c148, '149S' as c149, '150S' as c150,
'151S' as c151, '152T' as c152, '153T' as c153, '154T' as c154, '155T' as c155,
'156T' as c156, '157T' as c157, '158T' as c158, '159T' as c159, '160U' as c160,
'161U' as c161, '162U' as c162, '163U' as c163, '164U' as c164, '165U' as c165,
'166U' as c166, '167U' as c167, '168V' as c168, '169V' as c169, '170V' as c170,
'171V' as c171, '172V' as c172, '173V' as c173, '174V' as c174, '175V' as c175,
'176W' as c176, '177W' as c177, '178W' as c178, '179W' as c179, '180W' as c180,
'181W' as c181, '182W' as c182, '183W' as c183, '184X' as c184, '185X' as c185,
'186X' as c186, '187X' as c187, '188X' as c188, '189X' as c189, '190X' as c190,
'191X' as c191, '192Y' as c192, '193Y' as c193, '194Y' as c194, '195Y' as c195,
'196Y' as c196, '197Y' as c197, '198Y' as c198, '199Y' as c199, '200Z' as c200
      from dual;
      
    ut.expect(l_actual).to_equal(l_expected);
  end fill_all_colums;
--------------------------------------------------------------------------------
end imp_1_file_adapter_data_ut;
/
