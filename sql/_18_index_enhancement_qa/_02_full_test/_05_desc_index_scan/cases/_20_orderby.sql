--+ holdcas on;
create table tb (id int primary key, a int, b varchar(10));
insert into tb values (4,4,'4'), (1,1,'1');
create index i_tb_a on tb(a);
insert into tb values (2,2,'2'),(3,3,'3');
insert into tb values (5,5,'4'),(6,5,'3');

--TEST: should use index i_tb_a
select /*+ recompile */ * from tb where a > 0 order by a desc limit 3,10;
--TEST: should use index i_tb_a
select /*+ recompile */ * from tb where a > 0 order by a desc limit 4;
--TEST: should use index i_tb_a
select /*+ recompile */ * from tb where a > 0 order by a desc;
--TEST: should use index i_tb_a
select /*+ recompile use_desc_idx */ * from tb where a > 0 order by a asc;

drop table tb;
commit;
--+ holdcas off;
