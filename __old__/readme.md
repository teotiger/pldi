# PLDI

## Introduction

With **PL**/SQL **D**ata **I**ntegration it is possible to store files in a table (as BLOB) and - with the corresponding adapter (package) - transform the data (as VARCHAR2) into a single table  for further usage.

**PLDI** key features:

- adapter for CSV ("Character"-Delimited-Values) and XLSX (Microsoft Open XML) comes out of the box
- every PL/SQL statement or block can be executed after the processing ("push" info)
- to extract the data from a BLOB into a table, the default is reading the entire file from a directory object, but it is also possible to pass the BLOB directly from another table (for example **apex_collections**) or pass a big string (=CLOB)

## Installation

Download the `master.zip` archive and install **PLDI** with SQL*Plus or SQL Developer.

If you have already a directory object and user created, connect with the user and run the `install_headless.sql` file (pldi_directory is the only possible parameter).

If you do not have  a directory object and user created, connect as SYSDBA and run the `install.sql` file.

You can pass the following parameters:

1. pldi_directory (Default: **PLDI_FILES**)
2. pldi_path_name (Default: **/opt/ora_files**)
3. pldi_user (Default: **pldi**)
4. pldi_password Default: **pldi**)

Here is an example in Linux doing the whole installation in one command:

```bash
wget https://github.com/teotiger/pldi/archive/master.zip && unzip master.zip && cd pldi-master && sqlplus "sys/supersecretpassword@localhost as sysdba" @install.sql
```

## Usage / API

After successful installation define your meta data by using the `FILE_META_DATA_API` package. To read for example every TAB delimited file from your default directory (`select utils.default_directory from dual;`) use:
```plsql
begin
  file_meta_data_api.insert_row(
    i_keyword => 'tsv example',
    i_filename_match_filter => '*.tsv',
    i_filter_is_regular_expression => 0,
    i_fad_id => 1,
    i_character_set => 'UTF-8',
    i_delimiter => chr(9),
    i_enclosure => null,
    i_plsql_after_processing => null);
end;
/
```

See `examples/example_usage.sql` and `examples/sample_data.sql` for more information.

## Tests

PLDI is using [utPLSQL](https://github.com/utPLSQL/utPLSQL) for UnitTests.

Run one of the following commands inside your PLDI schema to get information about the tests:

```sql
-- plsql
exec ut.run();
-- sql
select * from table(ut.run());
```

## Data Model

![Data Model](images/data_model_pldi.jpg)

Every table has its own api package for DML operations.

## Credits

- Alexandria PL/SQL Utility Library https://github.com/mortenbra/alexandria-plsql-utils
- Blogpost from Carsten Czarski https://blogs.oracle.com/apex/easy-xlsx-parser:-just-with-sql-and-plsql
- Anton Scheffer http://technology.amis.nl/blog (code found here https://github.com/yallie/as_zip)
- OraOpenSource http://www.oraopensource.com/

## License

PLDI is released under the [MIT license](https://github.com/teotiger/pldi/blob/master/license.txt).

## Version History

Version 1.0.0 - October 14, 2019

- bugfix csv adapter (`imp_1_file_adapter_data`/`utils`):
  - support for  Windows OS line ending (CRLF)
- new table `FILE_PROCESSING_DATA` with logging infos and corresponding `FILE_PROCESSING_DATA_API` package
- new function `PROCESSING_FROM_RAW` and procedure `PROCESSING_FROM_TEXT` to restart file processing in `UTILS` package







!!!! COMPLETE NEW!!!!!!!!!!!!!!!





Version 0.9.9 - September 29, 2019

- bugfix csv adapter (`imp_1_file_adapter_data`/`utils`):
  - remove support for enclosure char inside text with enclosure 
  - bugfix handling of linebreaks inside text with enclosure
- `example_usage.sql` updated

Version 0.9.8 - September 24, 2019

- bugfix csv adapter (`imp_1_file_adapter_data`):
  - support for enclosure char inside text with enclosure
  - correct handling of linebreaks inside text with enclosure
- bugfix xlsx adapter (`imp_2_file_adapter_data`):
  - correct sheet_name
  - correct sheet_id
  - extract all 200 columns :)
  - correct display of dates
- finetuning in api packages (description and unit tests)

Version 0.9.7 - May 13, 2019

- bugfix in csv adapter (remove trailing spaces and linebreaks)
- revision of unit tests:
  - every package should have their own testpackage
  - naming convention is packagename + underscore + suffix "ut"

Version 0.9.6 - May 8, 2019

- bugfix in csv adapter (irregular number of cells each row)
- rename adapter packages
- substitution variable FTD_ID (in `utils.processing_file`) changed from `$FTD_ID` to `%FTD_ID%` 

Version 0.9.5 - May 5, 2019

- adapter for excel files (xlsx) introduced
- file_adapter_data_imp_* signature extended and (order) changed
- in table FILE_META_DATA columns changed (`FILENAME_MATCH_FILTER` and `FILTER_IS_REGULAR_EXPRESSION` replaces `FILENAME_MATCH_LIKE` and `FILENAME_MATCH_REGEXP_LIKE`, `CHARACTER_SET` is changed to `ORA_CHARSET_NAME`)

Version 0.9.2 – April 11, 2019

- in table FILE_TEXT_DATA columns extended from 50 to 200
- bugfix in package FILE_ADAPTER_DATA_IMP_1

Version 0.9.1 – March 26, 2019

Version 0.9 – March 18, 2019