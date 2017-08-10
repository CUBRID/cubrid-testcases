create table d (a int, b int);
insert into d values (1, 1), (2, 2), (3, 3);

select /*+ recompile */ * from d where a >= ( select a from d order by b desc for orderby_num() = 1);
drop table d;