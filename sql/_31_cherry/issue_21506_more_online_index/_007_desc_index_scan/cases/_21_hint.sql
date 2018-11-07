--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (id int primary key, a int, b varchar(10));
insert into tb values (4,4,'4'), (1,1,'1');
create index i_tb_a on tb(a) with online;
insert into tb values (2,2,'2'),(3,3,'3');
insert into tb values (5,5,'4'),(6,6,'3');

--TEST
select /*+ recompile use_desc_idx */ * from tb where a > 0 and rownum<10 using index i_tb_a;

drop table tb;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
