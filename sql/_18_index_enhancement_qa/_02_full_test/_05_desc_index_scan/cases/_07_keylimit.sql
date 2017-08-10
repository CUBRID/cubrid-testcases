--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (id int primary key, a int);
insert into tb values (4,4);
insert into tb values (1,1);
create index i_tb_a on tb(a);
insert into tb values (2,2);
insert into tb values (3,3);

--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 3 using index i_tb_a keylimit 2;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 3 using index i_tb_a keylimit 0;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 3 using index i_tb_a keylimit -1;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 3 using index i_tb_a keylimit 1,1;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 3 using index i_tb_a keylimit 1,2;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 3 using index i_tb_a keylimit 3,1;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 3 using index i_tb_a keylimit 4,4;

drop table tb;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
