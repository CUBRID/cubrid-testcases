--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (a int not null, b int);
create index i_tb_all on tb(a,b) with online;
create index i_tb_b on tb(b) with online;

select /*+ recompile */ * from tb where a is null;
select /*+ recompile */ * from tb where b is null or b is not null;
select /*+ recompile */ b from tb where b >0;

drop table tb;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
