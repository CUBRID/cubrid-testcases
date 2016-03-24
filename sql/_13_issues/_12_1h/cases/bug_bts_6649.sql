--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table foo (a int, c int);
create index foo_a on foo (a);

insert into foo values (1,10);
insert into foo values (2,10);
insert into foo values (3,10);
insert into foo values (4,10);
insert into foo values (5,10);
insert into foo values (6,10);
insert into foo values (7,10);
insert into foo values (8,10);
insert into foo values (9,10);
insert into foo values (10,10);

create table bar (a int, c int);
create index bar_a on bar (a);
insert into bar values (1, 20);
insert into bar values (3, 20);
insert into bar values (5, 20);
insert into bar values (7, 20);
insert into bar values (9, 20);

select /*+ recompile */ count(*) from foo f, bar b where f.a > 0 and f.a = b.a and rownum <= 4;

select /*+ recompile */ f.c, b.c from foo f, bar b where f.a > 0 and f.a = b.a and rownum <= 4;

select /*+ ordered */ count(*) from foo f, bar b where f.a > 0 and f.a = b.a and rownum <= 4 using index none;

drop table foo;
drop table bar;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

