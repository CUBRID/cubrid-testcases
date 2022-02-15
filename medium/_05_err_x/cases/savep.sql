autocommit off;
savepoint "foo";
rollback work to savepoint "bar";
select * from faculty;
rollback;
