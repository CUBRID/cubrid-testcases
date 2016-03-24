--TEST: When passing a float argument to Oracle functions, the behavior should be consistent in CUBRID.

drop table if exists foo;

create table foo(a int, b int);
insert into foo values(1, 1);
insert into foo values(2, 2);
insert into foo values(3, 3);
insert into foo values(4, 4);

select a, width_bucket(a, 0, 1, 3.7) from foo order by 1, 2;

drop table foo;
