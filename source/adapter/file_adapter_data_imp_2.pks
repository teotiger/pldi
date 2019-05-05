create or replace package file_adapter_data_imp_2 authid definer as
--------------------------------------------------------------------------------
-- This package ist heavily based on AS_ZIP from Anton Scheffer and the blogpost
-- from Carsten  Czarski:
-- https://blogs.oracle.com/apex/easy-xlsx-parser%3a-just-with-sql-and-plsql
--------------------------------------------------------------------------------
/*******************************************************************************
**
** Author: Anton Scheffer
** Date: 25-01-2012
** Website: http://technology.amis.nl/blog
**
** Changelog:
**   Date: 04-08-2016
**     fixed endless loop for empty/null zip file
**   Date: 28-07-2016
**     added support for defate64 (this only works for zip-files created with 7Zip)
**   Date: 31-01-2014
**     file limit increased to 4GB
**   Date: 29-04-2012
**    fixed bug for large uncompressed files, thanks Morten Braten
**   Date: 21-03-2012
**     Take CRC32, compressed length and uncompressed length from
**     Central file header instead of Local file header
**   Date: 17-02-2012
**     Added more support for non-ascii filenames
**   Date: 25-01-2012
**     Added MIT-license
**     Some minor improvements
******************************************************************************
******************************************************************************
Copyright (C) 2010,2011 by Anton Scheffer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*******************************************************************************/

--zip_blob_to_files[blob] r vc2_tt
--file_blob_from_zip_blob[filename] r blob
--
--excel_shared_strings
--excel_date...

  -- This procedure try to extract the binary data to structured tabular data.
  -- @The file-raw-data-ID (primary key from FILE_RAW_DATA table).
  -- @The file-meta-data-ID (primary key from FILE_META_DATA table).
  -- @The file-text-data-ID from FILE_TEXT_DATA table.
  -- @The binary large object.
  -- @The Oracle character set id to encode the file.
  -- @The Oracle character set name to encode the file.
  procedure insert_file_text_data(
    i_frd_id            in file_raw_data.frd_id%type,
    i_fmd_id            in file_meta_data.fmd_id%type,
    i_ftd_id            in file_text_data.ftd_id%type,
    i_blob_value        in file_raw_data.blob_value%type,
    i_ora_charset_id    in file_meta_data.ora_charset_id%type,
    i_ora_charset_name  in file_meta_data.ora_charset_name%type);
    
  -- => as_zip.get_file_list                                                    -- utils? plutil?
  function zipped_blob_to_files (
      i_zipped_blob       in blob,
      i_ora_charset_name  in varchar2,
      i_filter_sheet_name in boolean)
    return sys.ora_mining_varchar2_nt deterministic;

  -- => as_zip.get_file / apex_zip.get_file_content                             -- utils? plutil?
  function file_blob_from_zipped_blob (
      i_zipped_blob       in blob,
      i_ora_charset_name  in varchar2,
      i_filename          in varchar2)
    return blob deterministic;

end file_adapter_data_imp_2;
/