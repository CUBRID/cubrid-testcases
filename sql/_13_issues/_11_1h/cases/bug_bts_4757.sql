--+ holdcas on;

set  system parameters 'dont_reuse_heap_file=yes';
create table tb (id int primary key, a INT);
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);
insert into tb values (4,4);
create index i_tb_a on tb(a);

--after execute this query, you will find hint name is USE_IDX_DESC
select /*+ recompile */ * from tb where a between 2 and 4 order by a desc;

--after execute, you will no expect hind adopt
select /*+ recompile USE_IDX_DESC */ * from tb where a between 2 and 4;

--USE_DESC_IDX is as hint name. desc index scan is adopt.
select /*+ recompile USE_DESC_IDX */ * from tb where a between 2 and 4;


drop table tb;
set  system parameters 'dont_reuse_heap_file=no';

commit;

--+ holdcas off;

