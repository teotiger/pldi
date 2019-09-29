create or replace package body utils
as
--------------------------------------------------------------------------------
  function version return varchar2 deterministic
  is
    c_version constant varchar2(8 char) := 'v0.9.9';
  begin
    return c_version;
  end version;
-------------------------------------------------------------------------------- 
  function default_directory 
    return varchar2 deterministic
  is
    c_dir constant varchar2(30 char):='&pldi_directory.';
  begin
    return c_dir;
  end default_directory;
--------------------------------------------------------------------------------
  function blob_to_clob (
      i_blob_value     in blob,
      i_ora_charset_id in number)
    return clob deterministic
  is
    l_blob_value blob not null:=i_blob_value;
    l_ora_charset_id number not null:=i_ora_charset_id;
    l_clob clob;
    l_dest_offset integer := 1;
    l_src_offset integer := 1;
    l_lang_context integer := sys.dbms_lob.default_lang_ctx;
    l_warning  integer;
  begin
    sys.dbms_lob.createtemporary(
      lob_loc => l_clob,
      cache => true);
    sys.dbms_lob.converttoclob(
      dest_lob => l_clob, 
      src_blob => l_blob_value,
      amount => sys.dbms_lob.lobmaxsize,
      dest_offset => l_dest_offset,
      src_offset => l_src_offset,
      blob_csid => l_ora_charset_id,
      lang_context => l_lang_context,
      warning => l_warning);
    return l_clob;
  end blob_to_clob;  
--------------------------------------------------------------------------------
  function clob_to_blob (
      i_clob_value     in clob,
      i_ora_charset_id in number)
    return blob deterministic
  is
    l_clob_value clob not null:=i_clob_value;
    l_ora_charset_id number not null:=i_ora_charset_id;
    l_blob blob; 
    l_dest_offset integer := 1;
    l_src_offset integer := 1;
    l_lang_context integer := sys.dbms_lob.default_lang_ctx;
    l_warning  integer;
  begin
    sys.dbms_lob.createtemporary(
      lob_loc => l_blob,
      cache => true); 
    sys.dbms_lob.converttoblob(
      dest_lob => l_blob,
      src_clob => l_clob_value,
      amount => length(l_clob_value),
      dest_offset => l_dest_offset,
      src_offset => l_src_offset,
      blob_csid => l_ora_charset_id,
      lang_context => l_lang_context,
      warning => l_warning);
    return l_blob;
  end clob_to_blob;
--------------------------------------------------------------------------------
  function split_varchar2 (
      i_string_value    in varchar2,
      i_delimiter       in varchar2,
      i_enclosure       in varchar2,
      i_trim_enclosure  in boolean)
    return sys.ora_mining_varchar2_nt deterministic
  is
    l_del varchar2(1 char) not null:=i_delimiter;
    l_out sys.ora_mining_varchar2_nt:=sys.ora_mining_varchar2_nt();
    l_len pls_integer:=length(i_string_value);
    l_idx pls_integer:=1;
    l_pos pls_integer:=1;
    l_is_new boolean:=true;
    l_current varchar2(1 char);
    l_next varchar2(1 char);
    l_value varchar2(32767 char):=null;
    l_is_quoted boolean:=false;  
    l_quote varchar2(1 char):=i_enclosure;
    l_quote_count pls_integer:=0;
    -- save value and reset start flag
    procedure save_value is
    begin
      l_is_new:=true;
      l_is_quoted:=false;
      l_out.extend;
      l_out(l_idx):=l_value;
      l_idx:=l_idx+1;
      l_value:=null;
    end save_value;  
    -- append a char (l_current) to the string value (l_value)
    procedure append_to_value is
    begin
      l_value:=l_value||l_current;
    end append_to_value;

  begin

    while l_pos <= l_len
    loop
      -- find the current and the next character
      l_current:=substr(i_string_value, l_pos, 1);
      l_next:=substr(i_string_value, l_pos+1, 1);
  
      -- count quotes to avoid "false" delimiters
      if l_quote is not null and l_current=l_quote then
        l_quote_count:=l_quote_count+1;
      end if;
  
      -- reset variables
      if l_is_new then
        l_is_new:=false;
        -- check for leading quote and set quote flag
        l_is_quoted:=l_current=l_quote and l_quote is not null;
        if l_is_quoted then
          if i_trim_enclosure then
            l_pos:=l_pos+1;
          end if;
          continue;
        end if;
      end if;
  
      -- standard or quoted?
      if not l_is_quoted then
        if l_current=l_del and mod(l_quote_count,2)=0 then
          save_value;
        else
          append_to_value;
        end if;
      else
        if l_current=l_quote and nvl(l_next,l_del)=l_del then
          if not i_trim_enclosure then
            append_to_value;
          end if;
          l_pos:=l_pos+1;
          save_value;
        else
          append_to_value;
        end if;
      end if;
  
      -- at the end don't forget to save...
      if l_pos=l_len then
        save_value;
      end if;
  
      l_pos:=l_pos+1;
    end loop;
  
    return l_out;
  end split_varchar2;
--------------------------------------------------------------------------------
  procedure processing_file (
      i_filename in varchar2)
  is
    l_filename file_raw_data.filename%type not null:=i_filename;
    l_ftd_id   file_text_data.ftd_id%type;
    l_plsql    file_meta_data.plsql_after_processing%type;
  begin
    l_ftd_id:=file_text_data_api.insert_rows(
                i_frd_id => file_raw_data_api.insert_row(i_filename=>l_filename)
              );

    select max(plsql_after_processing)
      into l_plsql
      from file_meta_data fmd 
     where l_filename like case when fmd.filter_is_regular_expression=0 
                            then replace(fmd.filename_match_filter, '*', '%')
                            else l_filename
                           end
       and regexp_like(l_filename, case when fmd.filter_is_regular_expression=1 
                                    then fmd.filename_match_filter 
                                    else l_filename
                                   end);

    if l_plsql is not null and l_ftd_id is not null then
      execute immediate replace(l_plsql, '%FTD_ID%', l_ftd_id);
    end if;
  end processing_file;
--------------------------------------------------------------------------------
end utils;
/
