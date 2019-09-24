create or replace package body file_meta_data_api
as
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  function get_valid_ora_charset_name(
      i_character_set in varchar2)
    return varchar2 deterministic
  is
    type charset_names_t is varray(56) of varchar2(16 char);
    c_valid_charset_names constant charset_names_t:=charset_names_t('AL16UTF16',
      'AL32UTF8', 'AR8ADOS720', 'AR8ASMO8X', 'AR8ISO8859P6', 'AR8MSWIN1256',
      'AZ8ISO8859P9E', 'BLT8CP921', 'BLT8ISO8859P13', 'BLT8MSWIN1257',
      'BLT8PC775', 'CEL8ISO8859P14', 'CL8ISO8859P5', 'CL8KOI8R', 'CL8KOI8U',
      'CL8MSWIN1251', 'EE8ISO8859P2', 'EE8MSWIN1250', 'EE8PC852', 
      'EL8ISO8859P7', 'EL8MSWIN1253', 'EL8PC737', 'ET8MSWIN923', 'IW8ISO8859P8',
      'IW8MSWIN1255', 'JA16EUC', 'JA16EUCTILDE', 'JA16SJIS', 'JA16SJISTILDE',
      'KO16KSC5601', 'KO16MSWIN949', 'LT8MSWIN921', 'NE8ISO8859P10',
      'NEE8ISO8859P4', 'RU8PC866', 'SE8ISO8859P3', 'TH8TISASCII',
      'TR8MSWIN1254', 'TR8PC857', 'US7ASCII', 'US8PC437', 'UTF8',
      'VN8MSWIN1258', 'WE8ISO8859P1', 'WE8ISO8859P15', 'WE8ISO8859P9',
      'WE8MSWIN1252', 'WE8PC850', 'WE8PC858', 'ZHS16CGB231280', 'ZHS16GBK',
      'ZHS32GB18030', 'ZHT16BIG5', 'ZHT16HKSCS', 'ZHT16MSWIN950', 'ZHT32EUC');
    c_default_ora_charset_name constant varchar2(16 char):='AL32UTF8';
    l_ora_charset_name file_meta_data.ora_charset_name%type not null:=i_character_set;
    l_is_valid_ora_name boolean:=false;
  begin
    l_ora_charset_name:=upper(l_ora_charset_name);
    
    -- check if input is valid ora name
    for i in 1..c_valid_charset_names.count loop
      if l_ora_charset_name=c_valid_charset_names(i) then
        l_is_valid_ora_name:=true;
        exit;
      end if;
    end loop;
    
    -- try mapping (if necessary) with fallback option to default
    if not l_is_valid_ora_name then
      l_ora_charset_name:=nvl(
                            utl_i18n.map_charset(charset => l_ora_charset_name, 
                                                 context => utl_i18n.generic_context,
                                                 flag => utl_i18n.iana_to_oracle),
                            c_default_ora_charset_name
                          );
    end if;
    
    return l_ora_charset_name;
  end get_valid_ora_charset_name;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  procedure insert_row (
    i_keyword                       in file_meta_data.keyword%type,
    i_filename_match_filter         in file_meta_data.filename_match_filter%type,
    i_filter_is_regular_expression  in file_meta_data.filter_is_regular_expression%type,
    i_fad_id                        in file_meta_data.fad_id%type,
    i_character_set                 in file_meta_data.ora_charset_name%type,
    i_delimiter                     in file_meta_data.delimiter%type,
    i_enclosure                     in file_meta_data.enclosure%type,
    i_plsql_after_processing        in file_meta_data.plsql_after_processing%type)
  is
    l_keyword                       file_meta_data.keyword%type not null:=i_keyword ;
    l_filename_match_filter         file_meta_data.filename_match_filter%type not null:=i_filename_match_filter;
    l_filter_is_regular_expression  file_meta_data.filter_is_regular_expression%type not null:=i_filter_is_regular_expression;
    l_fad_id                        file_meta_data.fad_id%type not null:=i_fad_id;
    l_character_set                 file_meta_data.ora_charset_name%type not null:=i_character_set;
    l_ora_charset_name              file_meta_data.ora_charset_name%type;
  begin
    l_ora_charset_name:=get_valid_ora_charset_name(l_character_set);
    insert into file_meta_data (
      fmd_id,
      keyword,
      filename_match_filter,
      filter_is_regular_expression,
      fad_id,
      ora_charset_name,
      delimiter,
      enclosure,
      plsql_after_processing
    ) values (
      file_meta_data_seq.nextval,
      l_keyword,
      l_filename_match_filter,
      l_filter_is_regular_expression,
      l_fad_id,
      l_ora_charset_name,
      i_delimiter,
      i_enclosure,
      i_plsql_after_processing
    );
    commit;
  end insert_row;
--------------------------------------------------------------------------------
  procedure update_row (
    i_fmd_id                        in file_meta_data.fmd_id%type,
    i_keyword                       in file_meta_data.keyword%type,
    i_filename_match_filter         in file_meta_data.filename_match_filter%type,
    i_filter_is_regular_expression  in file_meta_data.filter_is_regular_expression%type,
    i_fad_id                        in file_meta_data.fad_id%type,
    i_character_set                 in file_meta_data.ora_charset_name%type,
    i_delimiter                     in file_meta_data.delimiter%type,
    i_enclosure                     in file_meta_data.enclosure%type,
    i_plsql_after_processing        in file_meta_data.plsql_after_processing%type)
  is
    l_fmd_id file_meta_data.fmd_id%type not null:=i_fmd_id;
    l_ora_charset_name file_meta_data.ora_charset_name%type;
  begin
    if i_character_set is not null then
      l_ora_charset_name:=get_valid_ora_charset_name(i_character_set);
    end if;
    
    update file_meta_data
       set keyword=nvl(i_keyword,keyword),
           filename_match_filter=nvl(i_filename_match_filter,filename_match_filter),
           filter_is_regular_expression=nvl(i_filter_is_regular_expression,filter_is_regular_expression),
           fad_id=nvl(i_fad_id,fad_id),
           ora_charset_name=nvl(l_ora_charset_name,ora_charset_name),
           delimiter=nvl(i_delimiter,delimiter),
           enclosure=nvl(i_enclosure,enclosure),
           plsql_after_processing=nvl(i_plsql_after_processing,plsql_after_processing)
     where fmd_id=l_fmd_id;
    commit;
  end update_row;
--------------------------------------------------------------------------------
  procedure delete_row (
    i_fmd_id       in file_meta_data.fmd_id%type,
    i_force_delete in boolean default false)
  is
    l_fmd_id file_meta_data.fmd_id%type not null:=i_fmd_id;
    l_force_delete boolean not null:=i_force_delete;
  begin
    if l_force_delete then
      delete file_text_data 
       where fmd_id=l_fmd_id;
    end if;
    
    delete file_meta_data 
     where fmd_id=l_fmd_id;
    commit;
  end delete_row;  
--------------------------------------------------------------------------------
end file_meta_data_api;
/