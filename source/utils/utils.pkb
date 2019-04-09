create or replace package body utils
as
--------------------------------------------------------------------------------
  function version return varchar2 deterministic
  is
    c_version constant varchar2(8 char) := 'v0.9.2';
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
      i_blob_value in blob,
      i_charset_id in number)
    return clob deterministic
  is
    l_blob_value blob not null:=i_blob_value;
    l_charset_id number not null:=i_charset_id;
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
      blob_csid => l_charset_id,
      lang_context => l_lang_context,
      warning => l_warning);
    return l_clob;
  end blob_to_clob;  
--------------------------------------------------------------------------------
  function clob_to_blob (
      i_clob_value in clob,
      i_charset_id in number)
    return blob deterministic
  is
    l_clob_value clob not null:=i_clob_value;
    l_charset_id number not null:=i_charset_id;
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
      blob_csid => l_charset_id,
      lang_context => l_lang_context,
      warning => l_warning);
    return l_blob;
  end clob_to_blob;
--------------------------------------------------------------------------------
  function split_varchar2 (
      i_string_value in varchar2,
      i_delimiter    in varchar2,
      i_enclosure    in varchar2)
    return sys.ora_mining_varchar2_nt deterministic
  is
-->  https://raw.githubusercontent.com/mortenbra/alexandria-plsql-utils/master/ora/csv_util_pkg.pkb
    p_separator varchar2(1 char) := i_delimiter;
    l_returnvalue      sys.ora_mining_varchar2_nt := sys.ora_mining_varchar2_nt();
    l_length           pls_integer     := length(i_string_value);
    l_idx              binary_integer  := 1;
    l_quoted           boolean         := false;  
    l_quote  constant  varchar2(1 char) := i_enclosure;
    l_start            boolean := true;
    l_current          varchar2(1 char);
    l_next             varchar2(1 char);
    l_position         pls_integer := 1;
    l_current_column   varchar2(32767 char);
    
    --Set the start flag, save our column value
    procedure save_column is
    begin
      l_start := true;
      l_returnvalue.extend;        
      l_returnvalue(l_idx) := l_current_column;
      l_idx := l_idx + 1;            
      l_current_column := null;
    end save_column;
    
    --Append the value of l_current to l_current_column
    procedure append_current is
    begin
      l_current_column := l_current_column || l_current;
    end append_current;
  begin
  
    /*
   
    Purpose:      convert CSV line to array of values
   
    Remarks:      based on code from http://www.experts-exchange.com/Database/Oracle/PL_SQL/Q_23106446.html
   
    Who     Date        Description
    ------  ----------  --------------------------------
    MBR     31.03.2010  Created
    KJS     20.04.2011  Modified to allow double-quote escaping
    MBR     23.07.2012  Fixed issue with multibyte characters, thanks to Vadi..., see http://code.google.com/p/plsql-utils/issues/detail?id=13
   
    */
  
    while l_position <= l_length loop
    
      --Set our variables with the current and next characters
      l_current := substr(i_string_value, l_position, 1);
      l_next := substr(i_string_value, l_position + 1, 1);    
      
      if l_start then
        l_start := false;
        l_current_column := null;
      
        --Check for leading quote and set our flag
        l_quoted := l_current = l_quote;
        
        --We skip a leading quote character
        if l_quoted then goto loop_again; end if;
      end if;
  
      --Check to see if we are inside of a quote    
      if l_quoted then      
  
        --The current character is a quote - is it the end of our quote or does
        --it represent an escaped quote?
        if l_current = l_quote then
  
          --If the next character is a quote, this is an escaped quote.
          if l_next = l_quote then
          
            --Append the literal quote to our column
            append_current;
            
            --Advance the pointer to ignore the duplicated (escaped) quote
            l_position := l_position + 1;
            
          --If the next character is a separator, current is the end quote
          elsif l_next = p_separator then
            
            --Get out of the quote and loop again - we will hit the separator next loop
            l_quoted := false;
            goto loop_again;
          
          --Ending quote, no more columns
          elsif l_next is null then
  
            --Save our current value, and iterate (end loop)
            save_column;
            goto loop_again;          
            
          --Next character is not a quote
          else
            append_current;
          end if;
        else
        
          --The current character is not a quote - append it to our column value
          append_current;     
        end if;
        
      -- Not quoted
      else
      
        --Check if the current value is a separator, save or append as appropriate
        if l_current = p_separator then
          save_column;
        else
          append_current;
        end if;
      end if;
      
      --Check to see if we've used all our characters
      if l_next is null then
        save_column;
      end if;
  
      --The continue statement was not added to PL/SQL until 11g. Use GOTO in 9i.
      <<loop_again>> l_position := l_position + 1;
    end loop ;
    
    return l_returnvalue;
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
     where l_filename like replace(fmd.filename_match_like, '*', '%')
        or regexp_like(l_filename, fmd.filename_match_regexp_like);

    if l_plsql is not null and l_ftd_id is not null then
      execute immediate replace(l_plsql, '$FTD_ID', l_ftd_id);
    end if;
  end processing_file;
--------------------------------------------------------------------------------
end utils;
/
