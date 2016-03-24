--TEST: [Analytic Functions] Result of count() analytic function is incorrect when there is an order by clause and a limit clause in the select statement.


drop table if exists foo;

create table foo(a int primary key, b int, c varchar(10));
insert into foo values(1, 2, 'aaa');
insert into foo values(2, 3, 'bbb');
insert into foo values(3, 1, 'bbb');
insert into foo values(4, 3, 'bbb');
insert into foo values(5, 1, 'aaa');

select a, b, c, count(*) over() from foo limit 2;
select a, b, c, count(*) over() from foo order by b limit 2;
select a, b, c, count(*) over(partition by c) from foo order by b limit 3;
select a, b, c, count(*) over(order by b) from foo order by b limit 10;
select a, b, c, count(*) over(partition by a) from foo order by b limit 4;
select a, b, c, count(*) over(partition by null order by null) from foo order by b limit 2;
select a, b, c, count(*) over(partition by c order by b) from foo order by b limit 1;

drop table foo;


-- no index
create table foo(a int, b int, c varchar(10));
insert into foo values(1, 2, 'aaa');
insert into foo values(2, 3, 'bbb');
insert into foo values(3, 1, 'bbb');
insert into foo values(4, 3, 'bbb');
insert into foo values(5, 1, 'aaa');

select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo;

select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo order by a limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo where inst_num() > 1 and inst_num() < 4;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo where inst_num() mod 2 = 1;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo where inst_num() > 10;

drop table foo;

-- with index
create table foo(a int primary key, b int, c varchar(10));
insert into foo values(1, 2, 'aaa');
insert into foo values(2, 3, 'bbb');
insert into foo values(3, 1, 'bbb');
insert into foo values(4, 3, 'bbb');
insert into foo values(5, 1, 'aaa');

select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo where a > 0;

select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo where a > 0 limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo where a > 0 order by b limit 2;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo where a > 0 and inst_num() > 1 and inst_num() < 4;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo where a > 0 and inst_num() mod 2 = 1;
select a, b, c, row_number() over (order by a), row_number() over (order by b) from foo where inst_num() > 10;

drop table foo;
