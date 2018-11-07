--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
set system parameters 'compat_mode=mysql';

create table tb (id int primary key, a int, b varchar(10));
insert into tb values (4,4,'4444'), (1,1,'111111');
create index i_tb_ab on tb(a,b) with online;
create index i_tb_ba on tb(b,a) with online;
insert into tb values (2,2,'22222'),(3,3,'3333');
insert into tb values (5,5,'444'),(6,5,'333');

--TEST
select /*+ recompile */ * from tb where a between 1 and 5 and b between '1' and '9' order by a desc;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 5 and b between '1' and '9' using index i_tb_ab  keylimit 1,3;
--TEST
select /*+ recompile */ * from tb where a between 1 and 5 and b between '1' and '9' order by b desc;
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 5 and b between '1' and '9' using index i_tb_ba; 
--TEST
select /*+ recompile use_desc_idx */ * from tb where a between 1 and 5 and b between '1' and '9' using index i_tb_ba keylimit 1,3; 

--TEST
select /*+ recompile */ * from tb where a between 1 and 5 and b between '1' and '444' order by a desc, b desc;
--TEST
select /*+ recompile */ * from tb where a between 1 and 5 and b between '1' and '444' order by a desc, b asc;
--TEST
select /*+ recompile */ * from tb where a between 1 and 5 and b between '1' and '444' order by a desc, b;
--TEST
select /*+ recompile */ * from tb where a between 1 and 5 and b between '1' and '444' order by a asc, b desc;
--TEST
select /*+ recompile */ * from tb where a between 1 and 5 and b between '1' and '444' order by a asc, b asc;
--TEST
select /*+ recompile */ * from tb where a between 1 and 5 and b between '1' and '444' order by a, b;
--TEST
select /*+ recompile */ * from tb where a between 1 and 5 and b like '3%' order by a desc;

drop table tb;

set system parameters 'compat_mode=cubrid';
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
