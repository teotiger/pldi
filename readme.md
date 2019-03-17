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

Use WGET or CURL to download the archive and then UNZIP to extract it.

```bash
wget https://github.com/teotiger/pldi/archive/master.zip` && unzip master.zip && cd pldi-master
```

or

```bash
curl -O https://github.com/teotiger/pldi/archive/master.zip
unzip master.zip
cd pldi-master
```

Connect as SYSDBA to your database and use the `install.sql` file with or without parameters:

```bash
sqllus "sys/supersecretpassword@localhost as sysdba" @install
```

The 4 possible parameters are:
1. pldi_user (Default: 'pldi')
2. pldi_password (Default: 'pldi')
3. pldi_directory (Default: 'PLDI_FILES')
4. pldi_path_name (Default: '/media/sf_debora')

...