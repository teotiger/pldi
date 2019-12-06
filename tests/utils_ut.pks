create or replace package utils_ut authid definer as

  -- %suite(UnitTests for package UTILS)

  -- %test(Check Version taxonomy.)
  procedure version_check;

  -- %test(Verify that version is a string, not a number.)
  -- %throws(-6502)
  procedure version_is_not_a_number;

  -- %test(A string is returned as username.)
  procedure username_check;

  -- %test(Get mimetype from comma-separated value file)
  procedure mimetype_csv;

  -- %test(Get mimetype for unknown file extension.)
  procedure mimetype_unknown;

  -- %test(A valid directory is configured.)
  procedure directory_setting_is_correct;
  
  -- %test(A valid number of bytes is configured.)
  procedure max_bytes_setting_is_correct;

end utils_ut;
/
