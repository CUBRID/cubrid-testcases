--TEST: [Analytic Functions] Collection type column returns incorrect values when it is selected together with analytic functions.


drop table if exists foo;

create table foo(a set int, b set varchar);
insert into foo values({1, 2, 3}, {'a', 'b'});
insert into foo values({1, 2, 3}, {'a', 'b'});
insert into foo values({1, 2, 3}, {'e', 'b'});
insert into foo values({1, 3, 3}, {'a', 'b'});
insert into foo values({1, 3, 3}, {'c', 'b'});
insert into foo values({1, 4, 3}, {'b', 'b'});
insert into foo values({1, 5, 3}, {'b', 'b'});



select a, b from foo order by 1, 2;

select a, b, row_number() over() rn from foo order by 1,2,3;
select a, b, row_number() over(order by a, b) rn from foo order by 1,2,3;
select a, b, row_number() over(partition by a) rn from foo order by 1,2,3;
select a, b, row_number() over(partition by b) rn from foo order by 1,2,3;
select a, b, row_number() over(partition by a, b order by 2) rn from foo order by 1,2,3;
select a, b, row_number() over(partition by b order by 1, 2) rn from foo order by 1,2,3;


drop table foo;
