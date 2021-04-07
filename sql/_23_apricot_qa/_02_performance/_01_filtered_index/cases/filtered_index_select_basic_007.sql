--+ holdcas on;
create table tb (a int unique not null, b int not null);
create index i_tb_all on tb(a,b);
create index i_tb_b on tb(b) where a>3;
create index i_tb_a on tb(a desc) where b>2;
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);
insert into tb values (4,null);
insert into tb values (null, null);
insert into tb values (null, 1);
insert into tb values (5, 1);
--test
select /*+ recompile */ * from tb where a is null using index i_tb_all(+),i_tb_b(+),i_tb_a(+) order by a ;
--test useing index i_tb_all
select /*+ recompile */ * from tb where a>0 and b>2 using index i_tb_all(+),i_tb_b(+),i_tb_a(+) order by 1;

--test useing index i_tb_a
select /*+ recompile */ * from tb where a>0 and b>2 using index i_tb_b(+),i_tb_a(+) order by 1;

--test useing index i_tb_a
select /*+ recompile */ * from tb where a>0 and b>2 using index i_tb_b(+) order by 1;

--test useing index i_tb_a
select /*+ recompile */ * from tb where a between 1 and 2 and b>2 using index i_tb_b(+),i_tb_a(+) order by 1;


--test useing index i_tb_b 
select /*+ recompile */ * from tb where b>3 using index i_tb_all(+),i_tb_b(+),i_tb_a(+) order by 1;
--test not use index 
select /*+ recompile */ * from tb where b>3 using index i_tb_all(+),i_tb_a(+) order by 1;
select /*+ recompile */ b from tb where b>0 using index i_tb_b(+)order by 1;
select /*+ recompile */ a from tb where b>2 using index i_tb_all(+),i_tb_a(+) order by 1;
select /*+ recompile */ * from tb where b>1 using index i_tb_all(+),i_tb_b(+),i_tb_a(+) order by 1;
--test using i_tb_b 
select /*+ recompile */ a from tb where b>2 using index i_tb_all(+),i_tb_b(+),i_tb_a(+) order by 1;



--test useing index i_tb_all
select /*+ recompile */ a from tb where b>2 and a is not null using index i_tb_all(+),i_tb_b(+),i_tb_a(+)order by 1;

--test useing index i_tb_a
select /*+ recompile */ a from tb where b>2 and a is not null using index i_tb_b(+),i_tb_a(+)order by 1;
--test useing index i_tb_all
select /*+ recompile */ b from tb where a>3 using index i_tb_all(+),i_tb_b(+),i_tb_a(+) order by 1;

select /*+ recompile */ b from tb where a>3 and b is not null using index i_tb_all(+),i_tb_b(+),i_tb_a(+) order by 1;

drop table tb;



commit;
--+ holdcas off;
