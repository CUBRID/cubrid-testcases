--+ holdcas on;
create table tb (a int not null, b int);
create index i_tb_all on tb(a,b) where b is not null;
create index i_tb_b on tb(b) where a is not null;
create index i_tb_a on tb(a) where a is null;
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);
insert into tb values (4,null);

select /*+ recompile */ * from tb where a is null using index i_tb_all(+),i_tb_b(+),i_tb_a(+);
select /*+ recompile */ * from tb where b is null or b is not null using index i_tb_all(+),i_tb_b(+),i_tb_a(+);
select /*+ recompile */ b from tb where b >0 using index i_tb_all(+),i_tb_b(+),i_tb_a(+);
select /*+ recompile */ b from tb where a is not null using index i_tb_all(+),i_tb_b(+),i_tb_a(+);
select /*+ recompile */ b from tb where a >0 using index i_tb_all(+),i_tb_b(+),i_tb_a(+);

drop table tb;



commit;
--+ holdcas off;
