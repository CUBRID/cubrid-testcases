--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table tb (a int primary key, b int);
create index i_tb_all on tb(a,b) where b is not null;
create index i_tb_b on tb(b) where b is null;
--create index i_tb_a on tb(a) where a is null;
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);
insert into tb values (4,null);
--test should use index i_tb_a 
select /*+ recompile */ * from tb where a >0;
--test should not use index
select /*+ recompile */ * from tb where a is not null using index i_tb_all(+),i_tb_b(+);
--test should not use index
select /*+ recompile */ * from tb where b is null or b is not null using index i_tb_all(+),i_tb_b(+);
--test should  use index i_tb_all
select /*+ recompile */ * from tb where  b is not null using index i_tb_all(+);
--test should use index i_tb_b 
select /*+ recompile */ b from tb where b is null using index i_tb_b(+);
--should not use index 
select /*+ recompile */ b from tb where b >0 using index i_tb_b(+);

drop table tb;



set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
