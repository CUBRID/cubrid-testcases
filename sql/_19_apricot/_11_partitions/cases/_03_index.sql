--
--+ holdcas on;

create table tpr(i int)
partition by range (i)(
partition p_10 values less than (10),
partition p_20 values less than (20),
partition p_30 values less than (30),
partition p_100 values less than (100));

insert into tpr values (0), (1), (2), (3), (4), (5), (6), (7), (8), (9);
insert into tpr select i + 10 from tpr;
insert into tpr select i + 20 from tpr;

create index idx_tpr on tpr(i);
update statistics on tpr;

show indexes from tpr;
show indexes from tpr__p__p_10;
show indexes from tpr__p__p_20;
show indexes from tpr__p__p_30;
show indexes from tpr__p__p_100;

select /*+ recompile */ * from tpr where i > 35 order by 1;
select /*+ recompile */ * from tpr__p__p_10 where i > 5 order by 1;
select /*+ recompile */ * from tpr__p__p_20 where i > 15 order by 1;
select /*+ recompile */ * from tpr__p__p_30 where i > 25 order by 1;
select /*+ recompile */ * from tpr__p__p_100 where i > 35 order by 1;
commit;
--+ holdcas off;
drop table tpr;
