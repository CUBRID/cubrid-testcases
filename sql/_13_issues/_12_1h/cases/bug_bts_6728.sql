create table tb (a int not null , b int);

create index i_tb_all on tb(a,b) where b is null;

insert into tb values (1,1);

insert into tb values (2,null);

select /*+ recompile */ * from tb where  a>0 and b is not null using index i_tb_all(+);

alter index i_tb_all on tb rebuild;

select /*+ recompile */ * from tb where  a>0 and b is not null using index i_tb_all(+);

drop table tb;


