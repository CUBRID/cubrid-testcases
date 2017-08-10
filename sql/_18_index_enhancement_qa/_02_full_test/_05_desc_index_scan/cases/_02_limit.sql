--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (id int primary key, a INT, b VARCHAR(10));
insert into tb values (1,1,'1');
insert into tb values (2,2,'2');
create index i_tb_a on tb(a);
create index i_tb_b on tb(b);
insert into tb values (3,3,'3');
insert into tb values (4,4,'4');
--TEST:
select /*+ recompile */ * from tb where a between 2 and 4 order by a desc limit 2;
--TEST:
select /*+ recompile */ * from tb where b between '2' and '4' order by b desc limit 2;
--TEST:
select /*+ recompile */ * from tb where a between 4 and 2 order by a desc limit 2;
--TEST:
select /*+ recompile */ * from tb where b between '4' and '2' order by b desc limit 2;
--TEST:
select /*+ recompile */ * from tb where a between 2 and 4 order by a desc limit 1,3;
--TEST:
select /*+ recompile */ * from tb where b between '2' and '4' order by b desc limit 1,3;
--TEST:
select /*+ recompile */ * from tb where a between 4 and 2 order by a desc limit 1,3;
--TEST:
select /*+ recompile */ * from tb where b between '4' and '2' order by b desc limit 1,3;

--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 2 and 4 using index i_tb_a limit 2;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '2' and '4' using index i_tb_b limit 2;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 2 and 4 using index i_tb_a limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '2' and '4' using index i_tb_b limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 4 and 2 using index i_tb_a limit 2;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '4' and '2' using index i_tb_b limit 2;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 4 and 2 using index i_tb_a limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '4' and '2' using index i_tb_b limit 1,3;

select /*+ recompile use_desc_idx */ * from tb where a between 4 and 4 using index i_tb_a limit 2;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '4' and '4' using index i_tb_b limit 2;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where a between 4 and 4 using index i_tb_a limit 1,3;
--TEST:
select /*+ recompile use_desc_idx */ * from tb where b between '4' and '4' using index i_tb_b limit 1,3;

drop table tb;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
