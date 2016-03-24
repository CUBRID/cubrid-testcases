autocommit off;
create class e (class a int default 1, a float);
insert into e (a) values (2.71828);
select * from e;
select * from class e;
rollback work;
rollback;
