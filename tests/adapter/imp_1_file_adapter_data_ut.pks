create or replace package imp_1_file_adapter_data_ut authid definer as

  -- %suite(UnitTests for IMPLEMENTATION package IMP_1_FILE_ADAPTER_DATA)

  -- %test(Check complete import from csv files with variable columns)
  procedure complete_csv_import_w_var_cols;

  -- %test(Remove trailing spaces and linebreaks)
  procedure remove_csv_trailing_space_eol;

  -- %test(Check spliting csv with multiline cell content)
  procedure multiline_cell_csv_import;

  -- %test(Check escaping enclosure char)
  procedure escaping_enclosure_char;

  -- %test(Check if all the columns are filled)
  procedure fill_all_colums;

end imp_1_file_adapter_data_ut;
/
