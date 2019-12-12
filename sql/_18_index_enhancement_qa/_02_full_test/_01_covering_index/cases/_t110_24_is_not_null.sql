--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (a int );
create index i_tb_a on tb(a);
insert into tb values (1);
insert into tb values (2);
insert into tb values (3);
insert into tb values (null);

--expect covering index is used. In fact, it's fail.
select /*+ recompile */ * from tb where a is not null;
--covering index is used. Result is good.
select /*+ recompile */ * from tb where a >0;

drop table tb;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
