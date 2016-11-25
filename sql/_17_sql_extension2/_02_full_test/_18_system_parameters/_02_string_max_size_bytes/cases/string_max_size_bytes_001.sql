--+ holdcas on;
--test related functions

set system parameters 'string_max_size_bytes=1048576';

select length(space(1048576));
select length(space(1048578));
select length(space(129839238));

select length(repeat('x', 1048576));
select length(repeat(B'1', 1048580));
select length(repeat(N'x', 10485766));

select length(insert(space(1048575), 1, 1, 'bc'));
select insert(space(1048575), 1, 1, 'bcd');

select length(space(1048570) + repeat('a', 6));
select space(1048570) + repeat('a', 7);
select space(1048570) + repeat('a', 100);


create table foo(a int, b varchar);
insert into foo values(1, repeat('a', 1048000));
insert into foo values(1, repeat('a', 500));
insert into foo values(1, repeat('a', 74));
insert into foo values(2, repeat('a', 1048000));
insert into foo values(2, repeat('a', 500));
insert into foo values(2, repeat('a', 78));

set system parameters 'group_concat_max_len=1048576';
select length(b) from foo order by 1;
select a, length(group_concat(b)) from foo group by a order by 1;

set system parameters 'group_concat_max_len=100';
select length(b) from foo order by 1;
select a, group_concat(b order by b) from foo group by a order by 1;
select a, length(group_concat(b)) from foo group by a order by 1;

drop table foo;

set system parameters 'group_concat_max_len=1024';
commit;
--+ holdcas off;
