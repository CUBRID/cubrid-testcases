--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
set system parameters 'compat_mode=mysql';
create table tb (id int primary key, a int, b varchar(10));
insert into tb values (4,4, '4'), (1,1,'1');
create index i_tb_a on tb(a);
create index i_tb_b on tb(b);
create index i_tb_ab on tb(a,b);
insert into tb values (2,2,'2'),(3,3,'3');
--TEST
insert into tb select /*+ recompile */ a+4, a+4, to_char(a+4) from tb where a between 1 and 5 order by a desc;

--TEST
select /*+ recompile */ * from tb where a between 1 and 8 order by a desc;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 8 using index i_tb_ab;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 8 and 1 using index i_tb_ab;
--TEST
select /*+ recompile use_desc_idx */ a,b from tb where a between 1 and 8 using index i_tb_ab;
--TEST
select /*+ recompile use_desc_idx */ a,b from tb where a between 1 and 8 and b >= '4' using index i_tb_ab;
--TEST
select /*+ recompile use_desc_idx */ a,b from tb where a between 1 and 8 and b >= '4' using index i_tb_ab keylimit 1,4;
--TEST
select /*+ recompile use_desc_idx */ a,b from tb where a between 1 and 8 and b >= '4' and rownum>1 using index i_tb_ab;

--TEST
insert into tb select /*+ recompile use_desc_idx */ a+8, a+8, to_char(a+8) from tb where a between 1 and 4 using index i_tb_ab;
--TEST
select /*+ recompile */ * from tb where a between 1 and 16 order by a desc;

drop table tb;

set system parameters 'compat_mode=cubrid';
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
