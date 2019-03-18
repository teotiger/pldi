# PLDI

## Introduction

With **PL**/SQL **D**ata **I**ntegration you can read every binary file and - with the corresponding adapter - transform the (textual) data into a single table for further usage.

Core features are:

- binary files can be read from a directory object or, in the case of textual data, simply pass a CLOB parameter
- adapter for CSV ("Character"-Delimited-Values) comes out of the box
- you can define a PL/SQL statement to execute after the file processing

## Installation

Download the `master.zip`archive and install **PLDI** with SQL*Plus or SQL Developer (as SYSDBA!). 

If you use Linux, you can do all in one command:

```bash
wget https://github.com/teotiger/pldi/archive/master.zip` && unzip master.zip && cd pldi-master && sqllus "sys/supersecretpassword@localhost as sysdba" @install.sql
```

Use the `install.sql` file with or without the following parameters:

1. pldi_user (Default: **pldi**)
2. pldi_password Default: **pldi**)
3. pldi_directory (Default: **PLDI_FILES**)
4. pldi_path_name (Default: **/media/sf_debora**)

If you already have a user and directory, use the `install_headless.sql` and only pass the name of the directory as first parameter (mandatory).

## Tests

PLDI is using [utPLSQL](https://github.com/utPLSQL/utPLSQL) for UnitTests.

Run one of the following commands inside your PLDI schema to get information about the tests:

```sql
-- plsql
exec ut.run();
-- sql
select * from table(ut.run());
```

## Usage / API

After successfull installation and after passing all tests define your meta data by using the `FILE_META_DATA_API` package. To read for example every TAB delimited file use:
```plsql
begin

end;
```


## Credits

- Alexandria PL/SQL Utility Library https://github.com/mortenbra/alexandria-plsql-utils
- Blogpost from Carsten Czarski https://blogs.oracle.com/apex/easy-xlsx-parser:-just-with-sql-and-plsql
- OraOpenSource http://www.oraopensource.com/

## License

PLDI is released under the [MIT license](https://github.com/teotiger/pldi/blob/master/license.txt).

## ToDo / Roadmap

The next features will be: 
- adapter for XLSX
- more Unit Tests
- optimize CSV parser (with benchmark)
- ....

## Version History

Version 0.9 – March 18, 2019