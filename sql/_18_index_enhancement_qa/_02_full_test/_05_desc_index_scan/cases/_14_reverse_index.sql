--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (id int primary key, a int, b varchar(10));
insert into tb values (4,4,'4444'), (1,1,'111111');
create index i_tb_ba on tb(b,a);
create reverse index ir_tb_ba on tb(b,a);
insert into tb values (2,2,'22222'),(3,3,'3333');
insert into tb values (5,5,'444'),(6,5,'333');

--TEST
select /*+ recompile */ * from tb where b > '1' order by b desc;

--TEST
select /*+ recompile use_desc_idx */ * from tb where b > '1' using index i_tb_ba;

--TEST
select /*+ recompile use_desc_idx  */ * from tb where b > '1' using index ir_tb_ba;

drop table tb;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
