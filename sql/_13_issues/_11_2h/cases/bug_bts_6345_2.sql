autocommit off;
set system parameters 'dont_reuse_heap_file=yes';
create table foo (a int, b int);
create table bar (a int, b int);
create index i_bar_a_b on bar (a, b);

insert into foo values (1, 2);
insert into foo values (3, 4);

insert into bar values (1, 1);
insert into bar values (1, 2);

set optimization level 513;

select /*+ RECOMPILE ORDERED */ b.a, f.b, b.b+1 
from foo f, bar b
where b.a = 1 and f.b = b.b+1;

select /*+ RECOMPILE ORDERED */ b.a, f.b, b.b+1 
from foo f left outer join bar b on b.a = 1 and f.b = b.b+1;

drop table foo;
create table foo (i int, j int, k int);
create index i_foo_i_j on foo (i, j);

insert into foo values (1, 1, 1);
insert into foo values (2, 2, 2);
insert into foo values (3, 3, 3);

set optimization level 513;

select /*+ RECOMPILE ORDERED USE_IDX */ count (*)
from foo x, foo y
where x.i = y.i
and exists (select 1 from foo z where z.i = x.i+1 and z.j = y.j+1);

drop table foo;
drop table bar;

rollback;
set optimization level 1;
set system parameters 'dont_reuse_heap_file=no';
commit;
autocommit on;
