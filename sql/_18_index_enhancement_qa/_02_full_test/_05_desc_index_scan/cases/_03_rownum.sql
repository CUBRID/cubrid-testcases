--+ holdcas on;
create table tb (id int primary key, a INT, b VARCHAR(10));
insert into tb values (1,1,'1');
insert into tb values (2,2,'2');
create index i_tb_a on tb(a);
create index i_tb_b on tb(b);
insert into tb values (3,3,'3');
insert into tb values (4,4,'4');
--TEST:
select /*+ recompile */ * from tb where a between 2 and 4 and rownum<=2 order by a desc;
--TEST:
select /*+ recompile */ * from tb where a between 4 and 2 and rownum<=2 order by a desc;
--TEST:
select /*+ recompile */ * from tb where a between 2 and 4 and rownum between 1 and 2 order by a desc;
--TEST:
select /*+ recompile */ * from tb where a between 4 and 2 and rownum between 1 and 2 order by a desc;

--TEST:
select /*+ recompile */ * from tb where b between '2' and '4' and rownum<=2 order by b desc;
--TEST:
select /*+ recompile */ * from tb where b between '4' and '2' and rownum<=2 order by b desc;
--TEST:
select /*+ recompile */ * from tb where b between '2' and '4' and rownum between 1 and 2 order by b desc;
--TEST:
select /*+ recompile */ * from tb where b between '4' and '2' and rownum between 1 and 2 order by b desc;

--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 2 and 4 and rownum<=2 using index i_tb_a;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 2 and 4 and rownum between 1 and 2 using index i_tb_a;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 4 and 2 and rownum<=2 using index i_tb_a;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 4 and 2 and  rownum<=2 using index i_tb_a;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 4 and 4 and rownum<=2 using index i_tb_a;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 4 and 4 and rownum between 1 and 2 using index i_tb_a;

--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '2' and '4' and rownum<=2 using index i_tb_b;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '2' and '4' and rownum between 1 and 2 using index i_tb_b;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '4' and '2' and rownum<=2 using index i_tb_b;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '4' and '2' and rownum between 1 and 3 using index i_tb_b;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '4' and '4' and rownum<=2 using index i_tb_b;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '4' and '4' and rownum between 1 and 3 using index i_tb_b;

drop table tb;
commit;
--+ holdcas off;
