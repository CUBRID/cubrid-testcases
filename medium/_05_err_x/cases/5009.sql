autocommit off;
create class foo (a int);
insert into foo values(1);
insert into foo values(20);
create view vfoo as select * from foo order by a;
rollback;
