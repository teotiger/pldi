create or replace package body utils
as
--------------------------------------------------------------------------------
  function version return varchar2 deterministic
  is
    c_version constant varchar2(8 char) := 'v1.0.0';
  begin
    return c_version;
  end version;
--------------------------------------------------------------------------------
  function username return varchar2
  is
  begin
    return coalesce(sys_context('apex$session', 'app_user'),
                    sys_context('userenv', 'os_user'));
  end username;
--------------------------------------------------------------------------------
  function mimetype(i_filename in varchar2) return varchar2 deterministic
  is
    c_fallback constant varchar2(30 char):= 'application/octet-stream';
    type mimetypes_t is table of varchar2(255 char) index by varchar2(30 char);
    l_mimetypes mimetypes_t;
    procedure init is
    begin
      l_mimetypes('.aac'):='audio/aac';
      l_mimetypes('.bmp'):='image/bmp';
      l_mimetypes('.bz'):='application/x-bzip';
      l_mimetypes('.bz2'):='application/x-bzip2';
      l_mimetypes('.css'):='text/css';
      l_mimetypes('.csv'):='text/csv';
      l_mimetypes('.doc'):='application/msword';
      l_mimetypes('.docx'):='application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      l_mimetypes('.epub'):='application/epub+zip';
      l_mimetypes('.gz'):='application/gzip';
      l_mimetypes('.gif'):='image/gif';
      l_mimetypes('.htm'):='text/html';
      l_mimetypes('.html'):='text/html';
      l_mimetypes('.ico'):='image/vnd.microsoft.icon';
      l_mimetypes('.ics'):='text/calendar';
      l_mimetypes('.jar'):='application/java-archive';
      l_mimetypes('.jpeg'):='image/jpeg';
      l_mimetypes('.jpg'):='image/jpeg';
      l_mimetypes('.js'):='text/javascript';
      l_mimetypes('.json'):='application/json';
      l_mimetypes('.midi'):='audio/midi audio/x-midi';
      l_mimetypes('.mp3'):='audio/mpeg';
      l_mimetypes('.mpeg'):='video/mpeg';
      l_mimetypes('.odp'):='application/vnd.oasis.opendocument.presentation';
      l_mimetypes('.ods'):='application/vnd.oasis.opendocument.spreadsheet';
      l_mimetypes('.odt'):='application/vnd.oasis.opendocument.text';
      l_mimetypes('.otf'):='font/otf';
      l_mimetypes('.png'):='image/png';
      l_mimetypes('.pdf'):='application/pdf';
      l_mimetypes('.ppt'):='application/vnd.ms-powerpoint';
      l_mimetypes('.pptx'):='application/vnd.openxmlformats-officedocument.presentationml.presentation';
      l_mimetypes('.rar'):='application/x-rar-compressed';
      l_mimetypes('.rtf'):='application/rtf';
      l_mimetypes('.sh'):='application/x-sh';
      l_mimetypes('.svg'):='image/svg+xml';
      l_mimetypes('.tab'):='text/tab-separated-values';
      l_mimetypes('.tar'):='application/x-tar';
      l_mimetypes('.tif'):='image/tiff';
      l_mimetypes('.tiff'):='image/tiff';
      l_mimetypes('.tsv'):='text/tab-separated-values';
      l_mimetypes('.ttf'):='font/ttf';
      l_mimetypes('.txt'):=' (generally ASCII or ISO 8859-n)';
      l_mimetypes('.vsd'):='application/vnd.visio';
      l_mimetypes('.wav'):='audio/wav';
      l_mimetypes('.weba'):='audio/webm';
      l_mimetypes('.webm'):='video/webm';
      l_mimetypes('.webp'):='image/webp';
      l_mimetypes('.woff'):='font/woff';
      l_mimetypes('.woff2'):='font/woff2';
      l_mimetypes('.xhtml'):='application/xhtml+xml';
      l_mimetypes('.xls'):='application/vnd.ms-excel';
      l_mimetypes('.xlsx'):='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      l_mimetypes('.xml'):='text/xml';
      l_mimetypes('.zip'):='application/zip';
      l_mimetypes('.7z'):='application/x-7z-compressed';
    end init;
  begin
    init;
    return l_mimetypes( lower(substr(i_filename, instr(i_filename,'.',-1))) );
  exception
    when no_data_found then return c_fallback;
  end mimetype;
--------------------------------------------------------------------------------
  function directory_setting return varchar2 deterministic
  is
    c_dir constant varchar2(30 char):='&pldi_directory.';
  begin
    return c_dir;
  end directory_setting;
--------------------------------------------------------------------------------
  function max_bytes_setting return number deterministic 
  is
    c_max constant number:=to_number('&pldi_max_bytes.');
  begin
    return c_max;
  end max_bytes_setting;
--------------------------------------------------------------------------------

/*
function processing_from_raw (
      i_frd_id in number)
    return number
  is
    l_frd_id file_raw_data.frd_id%type not null:=i_frd_id;
  begin
    return file_text_data_api.insert_rows(i_frd_id => l_frd_id);
  end processing_from_raw;
--------------------------------------------------------------------------------
  procedure processing_from_text (
      i_ftd_id in number)
  is
    l_ftd_id file_text_data.ftd_id%type not null:=i_ftd_id;
    l_fmd_id file_meta_data.fmd_id%type;
    l_plsql  file_meta_data.plsql_after_processing%type;
  begin
    select max(fmd_id)
      into l_fmd_id
      from file_text_data
     where ftd_id=l_ftd_id;

    select max(plsql_after_processing)
      into l_plsql
      from file_meta_data fmd 
     where fmd_id=l_fmd_id;

    if l_plsql is not null and l_ftd_id is not null then
      execute immediate replace(l_plsql, '%FTD_ID%', l_ftd_id);
    end if;
  end processing_from_text;
--------------------------------------------------------------------------------
*/
/*
-- quasi step 2
  procedure processing_file(i_frd_id in number, fsd_id damit file_status_data_api.update_row)


-- quasi step 3
  procedure processing_file(i_ftd_id in number)
*/

  procedure processing_file(i_filename in varchar2)
  is
    c_no_data_found_error_message constant file_status_data.error_message%type
      :='WARN: No matching configuration found in FILE_META_DATA.';
    l_filename  file_raw_data.filename%type not null:=i_filename;
    l_fsd_id    file_status_data.fsd_id%type;
    l_frd_id    file_raw_data.frd_id%type;
    l_ftd_id    file_text_data.ftd_id%type;
    l_fmd_id    file_meta_data.fmd_id%type;
    l_fad_id    file_adapter_data.fad_id%type;
--    l_filesize  file_raw_data.filesize%type;
    l_start     number;
  begin
    l_fsd_id:=file_status_data_api.insert_row(i_filename => l_filename);

    -- step 1 -- reading file content as blob to table FILE_RAW_DATA
    l_start:=dbms_utility.get_time;
    l_frd_id:=file_raw_data_api.insert_row(i_filename => l_filename);
    file_status_data_api.update_row(
      i_fsd_id    => l_fsd_id,
      i_frd_id    => l_frd_id,
      i_seconds_1 => ((dbms_utility.get_time-l_start)/100));
    commit;

    -- step 2 -- try to extract content to FILE_TEXT_DATA
    l_start:=dbms_utility.get_time;
    file_text_data_api.insert_rows(
      i_frd_id => l_frd_id,
      o_ftd_id => l_ftd_id,
      o_fmd_id => l_fmd_id,
      o_fad_id => l_fad_id);
    file_status_data_api.update_row(
      i_fsd_id    => l_fsd_id,
      i_ftd_id    => l_ftd_id,
      i_fmd_id    => l_fmd_id,
      i_fad_id    => l_fad_id,
      i_seconds_2 => ((dbms_utility.get_time-l_start)/100));
    commit;

/*
    -- step 3 -- try to execute PLSQL Code if configured
    if l_ftd_id is not null then
      processing_from_text(i_ftd_id => l_ftd_id);
      stopwatch_finish(3);
    end if;
--    l_filename file_raw_data.filename%type not null:=i_filename;
--    l_ftd_id   file_text_data.ftd_id%type;
--    l_plsql    file_meta_data.plsql_after_processing%type;
--  begin
--    l_ftd_id:=file_text_data_api.insert_rows(
--                i_frd_id => file_raw_data_api.insert_row(i_filename=>l_filename)
--              );
--
--    select max(plsql_after_processing)
--      into l_plsql
--      from file_meta_data fmd 
--     where l_filename like case when fmd.filter_is_regular_expression=0 
--                            then replace(fmd.filename_match_filter, '*', '%')
--                            else l_filename
--                           end
--       and regexp_like(l_filename, case when fmd.filter_is_regular_expression=1 
--                                    then fmd.filename_match_filter 
--                                    else l_filename
--                                   end);
--
--    if l_plsql is not null and l_ftd_id is not null then
--      execute immediate replace(l_plsql, '%FTD_ID%', l_ftd_id);
--    end if;
*/


    -- step 4 -- housekeeping if enabled
    l_start:=dbms_utility.get_time;
    if file_raw_data_api.housekeeping(i_frd_id => l_frd_id)>0 then
--      file_text_data_api.housekeeping; -- alles wo in file_status_data bei frd_id -1 drinnen steht
--      file_status_data_api.housekeeping; -- alles wo in file_status_data bei frd_id -1 drinnen steht
  null;
    end if;
    file_status_data_api.update_row(
      i_fsd_id    => l_fsd_id,
      i_frd_id    => l_frd_id,
      i_seconds_4 => ((dbms_utility.get_time-l_start)/100));

    -- final transaction commit
    commit;

  exception 
    when no_data_found then 
      rollback;
      file_status_data_api.update_row(
        i_fsd_id => l_fsd_id,
        i_error_message => c_no_data_found_error_message);
    when others then
      rollback;
      file_status_data_api.update_row(
        i_fsd_id => l_fsd_id,
        i_error_message => dbms_utility.format_error_stack
                           ||dbms_utility.format_error_backtrace);
      raise;
  end processing_file;
--------------------------------------------------------------------------------



/*  
--------------------------------------------------------------------------------
  function processing_from_raw (
      i_frd_id in number)
    return number
  is
    l_frd_id file_raw_data.frd_id%type not null:=i_frd_id;
  begin
    return file_text_data_api.insert_rows(i_frd_id => l_frd_id);
  end processing_from_raw;
--------------------------------------------------------------------------------
  procedure processing_from_text (
      i_ftd_id in number)
  is
    l_ftd_id file_text_data.ftd_id%type not null:=i_ftd_id;
    l_fmd_id file_meta_data.fmd_id%type;
    l_plsql  file_meta_data.plsql_after_processing%type;
  begin
    select max(fmd_id)
      into l_fmd_id
      from file_text_data
     where ftd_id=l_ftd_id;

    select max(plsql_after_processing)
      into l_plsql
      from file_meta_data fmd 
     where fmd_id=l_fmd_id;

    if l_plsql is not null and l_ftd_id is not null then
      execute immediate replace(l_plsql, '%FTD_ID%', l_ftd_id);
    end if;
  end processing_from_text;
--------------------------------------------------------------------------------
  procedure processing_file (
      i_filename in varchar2)
  is
    l_filename  file_raw_data.filename%type not null:=i_filename;
    l_frd_id    file_raw_data.frd_id%type;
    l_ftd_id    file_text_data.ftd_id%type;
    l_fmd_id    file_meta_data.fmd_id%type;
    l_fad_id    file_adapter_data.fad_id%type;
    l_filesize  file_raw_data.filesize%type;
    l_start     number;
    --
    procedure stopwatch_finish(i_step in number) is
    begin
      case i_step
        when 1 then
          file_status_data_api.insert_row (
            i_frd_id        => l_frd_id,           
            i_filename      => 'file_raw_data_api.insert_row mit out para',
            i_filesize      => 10,--in file_raw_data.filesize%type,
            i_seconds_step1 => dbms_utility.get_time-l_start
          );
        when 2 then
          null;
          -- update ftd_id!
      end case;
    end stopwatch_finish;
  begin
    -- step 1 -- reading file content to table FILE_RAW_DATA
    l_start:=dbms_utility.get_time;
    l_frd_id:=file_raw_data_api.insert_row(i_filename => l_filename);
    stopwatch_finish(1);

    -- step 2 -- try to extract content to FILE_TEXT_DATA
    file_text_data_api.insert_rows(
      i_frd_id => l_frd_id,
      o_ftd_id => l_ftd_id,
      o_fmd_id => l_fmd_id,
      o_fad_id => l_fad_id,
      o_filename => l_filename,
      o_filesize => l_filesize);
    stopwatch_finish(2);

    -- step 3 -- try to execute PLSQL Code if configured
    if l_ftd_id is not null then
      processing_from_text(i_ftd_id => l_ftd_id);
      stopwatch_finish(3);
    end if;
--    l_filename file_raw_data.filename%type not null:=i_filename;
--    l_ftd_id   file_text_data.ftd_id%type;
--    l_plsql    file_meta_data.plsql_after_processing%type;
--  begin
--    l_ftd_id:=file_text_data_api.insert_rows(
--                i_frd_id => file_raw_data_api.insert_row(i_filename=>l_filename)
--              );
--
--    select max(plsql_after_processing)
--      into l_plsql
--      from file_meta_data fmd 
--     where l_filename like case when fmd.filter_is_regular_expression=0 
--                            then replace(fmd.filename_match_filter, '*', '%')
--                            else l_filename
--                           end
--       and regexp_like(l_filename, case when fmd.filter_is_regular_expression=1 
--                                    then fmd.filename_match_filter 
--                                    else l_filename
--                                   end);
--
--    if l_plsql is not null and l_ftd_id is not null then
--      execute immediate replace(l_plsql, '%FTD_ID%', l_ftd_id);
--    end if;
  end processing_file;
--------------------------------------------------------------------------------


*/ 
end utils;
/