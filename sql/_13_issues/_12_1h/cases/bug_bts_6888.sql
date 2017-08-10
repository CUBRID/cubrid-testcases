--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';

create table pt1(i int);
create table pt2(i int) partition by hash(i) partitions 4;

insert into pt1 values(1),(2),(3);
insert into pt2 values(1);

create index idx on pt2(i);

select /*+ recompile */ * from pt1 left join pt2 on pt1.i=pt2.i order by 1, 2;

select /*+ recompile */ * from pt1 left join pt2 on pt1.i = pt2.i order by 1, 2;

insert into pt2 values(1);

select /*+ recompile */ * from pt1 left join pt2 on pt1.i = pt2.i order by 1, 2;

insert into pt2 values(2);

select /*+ recompile */ * from pt1 left join pt2 on pt1.i = pt2.i order by 1, 2;

select /*+ recompile */ * from pt1 left join pt2 on pt1.i = pt2.i and pt1.i = 1 order by 1, 2;

select /*+ recompile */ * from pt1 left join pt2 on pt1.i = pt2.i and pt2.i = 1 order by 1, 2;

drop table pt1;
drop table pt2;

create table a(i int) partition by hash(i) partitions 4;
create table b(i int);

insert into b values(1),(2),(3);
insert into a values(1);

create index idx on b(i);

select /*+ recompile */ * from a right join b on a.i=b.i order by 1, 2;

select /*+ recompile */ * from b right join a on a.i=b.i order by 1, 2;

drop table a;
drop table b;

create table a(i int);
create table a1 under a(j int);
create table a2 under a1(k int);

create index i_a_i on a(i);

create table b (i int);

insert into b values(1),(2),(3),(5),(6);
insert into a values(1);
insert into a1 values(2,2);
insert into a2 values(3,3,3);

select /*+ recompile */ * from all a right join b on a.i=b.i order by 1, 2;

select /*+ recompile */ * from all a right join b on a.i=b.i where a.i = 2 order by 1, 2;

select /*+ recompile */ * from all a right join b on a.i=b.i where b.i = 2 order by 1, 2;

drop table a2;
drop table a1;
drop table a;
drop table b;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

