--
--+ holdcas on;

create table tph(i int)
partition by hash (i)
partitions 10;

insert into tph values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
insert into tph select i + 10 from tph;
insert into tph select i + 20 from tph;

create index idx_tph on tph(i);
update statistics on tph;

show indexes from tph;
show indexes from tph__p__p0;
show indexes from tph__p__p1;
show indexes from tph__p__p2;
show indexes from tph__p__p3;
show indexes from tph__p__p4;
show indexes from tph__p__p5;
show indexes from tph__p__p6;
show indexes from tph__p__p7;
show indexes from tph__p__p8;
show indexes from tph__p__p9;

select /*+ recompile */ * from tph where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p0 where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p1 where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p2 where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p3 where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p4 where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p5 where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p6 where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p7 where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p8 where i > 0 order by 1;
select /*+ recompile */ * from tph__p__p9 where i > 0 order by 1;

drop table tph;
commit;
--+ holdcas off;
