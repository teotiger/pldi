# PLDI
Data Integration with PLSQL.

## Tests

PLDI is using [utPLSQL](https://github.com/utPLSQL/utPLSQL) for UnitTests.

Run one of the following commands inside your PLDI schema to get information about the tests:

```sql
-- plsql
exec ut.run();
-- sql
select * from table(ut.run());
```



## Installation

Use WGET or CURL to download and then UNZIP to extract the archive.

```bash
wget https://github.com/teotiger/pldi/archive/master.zip` && unzip master.zip
```

or

```bash
curl -o https://github.com/teotiger/pldi/archive/master.zip
unzip master.zip
```

Connect as SYSDBA to your database and use the `install.sql` file with or without parameters:

```bash
sqplus "sys/supersecretpassword@localhost as sysdba" @install
```

The 4 possible parameters are:
1. asdsd (Default: ...)
2. asdsad
3. fdf
4. ad

asdsdas