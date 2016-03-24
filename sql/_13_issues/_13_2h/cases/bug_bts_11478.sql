--Test for min/max() with rollup

drop table if exists foo;
create table foo(col_1 int, col_2 int, col_3 int);
insert into foo values(60, 1, 1), (70, 2, 2),(50, 1, 2), (80, 2, 1),(90, 1, 2), (60, 1, 2);
select min(col_1), col_2, col_3 from foo group by col_2, col_3 with rollup;

drop table if exists foo2;
create table foo2(col_1 int, col_2 int, col_3 int);
insert into foo2 values(60, 1, 1), (70, 2, 2),(50, 1, 2), (80, 2, 1),(90, 1, 2), (60, 1, 2);
select max(col_1), col_2, col_3 from foo2 group by col_2, col_3 with rollup;

drop table foo;
drop table foo2;