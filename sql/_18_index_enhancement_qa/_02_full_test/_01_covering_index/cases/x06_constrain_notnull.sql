--+ holdcas on;
create table tb (a int not null, b int);
create index i_tb_all on tb(a,b);
create index i_tb_b on tb(b);

select /*+ recompile */ * from tb where a is null;
select /*+ recompile */ * from tb where b is null or b is not null;
select /*+ recompile */ b from tb where b >0;

drop table tb;

commit;
--+ holdcas off;
