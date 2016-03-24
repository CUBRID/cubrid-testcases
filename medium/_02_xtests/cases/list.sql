autocommit off;
create table foo (a list int);
insert into foo values(list{1,2,3});
select a from foo;
select cast(a as list float) from foo;
rollback;
