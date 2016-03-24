--+ holdcas on;
--test related functions

set system parameters 'string_max_size_bytes=100';

select length(space(100));
select length(space(101));
select length(space(200));

select length(repeat('x', 100));
select length(repeat(B'1', 101));
select length(repeat(N'x', 510));

select length(insert(space(99), 1, 1, 'bc'));
select insert(space(99), 1, 1, 'bcd');

select length(space(90) + repeat('a', 10));
select space(90) + repeat('a', 11);
select space(90) + repeat('a', 100);


create table foo(a int, b varchar);
insert into foo values(1, repeat('a', 90));
insert into foo values(1, repeat('a', 5));
insert into foo values(1, repeat('a', 3));
insert into foo values(2, repeat('a', 90));
insert into foo values(2, repeat('a', 5));
insert into foo values(2, repeat('a', 6));

select a, group_concat(b) from foo group by a order by 1;

drop table foo;

set system parameters 'string_max_size_bytes=1048576';
commit;
--+ holdcas off;
