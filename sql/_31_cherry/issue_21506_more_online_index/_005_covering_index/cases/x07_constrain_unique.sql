--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (a int unique, b int);
create index i_tb_all on tb(a,b) with online;
create index i_tb_b on tb(b) with online;
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);
insert into tb values (4,null);
insert into tb values (null, null);
insert into tb values (null, 1);
select /*+ recompile */ * from tb where a is null order by a;
select /*+ recompile */ * from tb where b is null or b is not null;
select /*+ recompile */ b from tb where b >0;


drop table tb;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
