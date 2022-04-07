autocommit off;
savepoint "foo";
rollback work to savepoint "bar";
select * from joe.faculty;
rollback;
