# PLDI
Data Integration with PLSQL.

# Tests

PLDI is using [utPLSQL](https://github.com/utPLSQL/utPLSQL) for UnitTests.

Run one of the following commands inside your PLDI schema to get information about the tests:

```sql
-- plsql
exec ut.run();
-- sql
select * from table(ut.run());
```
