--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table cov_t1 (id1 int, id2 varchar(30), id3 int);
insert into cov_t1 values (5,'mnpqrt',55);
insert into cov_t1 values (10,'abcd',100);
insert into cov_t1 values ( 11,'abmnp',111);
insert into cov_t1 values ( 15,'mnpde',111);
insert into cov_t1 values ( 5,'abcde',55);
insert into cov_t1 values ( 10,'abc',100);
insert into cov_t1 values ( 10,'abc',100);
insert into cov_t1 values (11,'ab ',111);
create index idx_covering_t1 on cov_t1 (id1, id2);
create index idx_t1_1_3 on cov_t1 (id1, id3);
create index idx_t1_2_3 on cov_t1 (id2, id3);
create index idx_t1_1_2_3 on cov_t1 (id1, id2, id3);

select /*+ recompile */ id2 from cov_t1 where id1 < 100 and id2 > 'abc';
select /*+ recompile */ id2 from cov_t1 where id1 < 100 and id2 > 'abc' order by id2 asc;
select /*+ recompile */ id2 from cov_t1 where id1 < 100 and id2 > 'abc' order by id2 desc ;

select /*+ recompile */ id2 from cov_t1 where id1 < 100 and id2 > 'abc' order by id1 desc;
select /*+ recompile */ id2 from cov_t1 where id1 < 100 and id2 > 'abc' order by id1 asc;

drop table cov_t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
