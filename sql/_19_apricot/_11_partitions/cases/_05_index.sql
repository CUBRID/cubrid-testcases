--
--+ holdcas on;

create table tpl(i int)
partition by list (i)(
partition prime values in (2, 5, 7, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97),
partition mul_3 values in (0, 3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36, 39, 42, 45, 48, 51, 54, 57, 60, 63, 66, 69, 72, 75, 78, 81, 84, 87, 90, 93, 96, 99),
partition pow_4 values in (1, 4, 16, 64));

insert into tpl values (2), (5), (7), (13), (17), (19), (23), (29), (31);
insert into tpl select i * 3 from tpl;
insert into tpl values (4), (16), (64);

create index idx_tpl on tpl(i);
update statistics on tpl;

show indexes from tpl;
show indexes from tpl__p__prime;
show indexes from tpl__p__mul_3;
show indexes from tpl__p__pow_4;

select /*+ recompile */ * from tpl where i > 0 order by 1;
select /*+ recompile */ * from tpl__p__prime where i > 0 order by 1;
select /*+ recompile */ * from tpl__p__mul_3 where i > 0 order by 1;
select /*+ recompile */ * from tpl__p__pow_4 where i > 0 order by 1;

drop table tpl;
commit;
--+ holdcas off;
