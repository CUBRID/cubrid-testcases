--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (a int);
insert into tb values (1);
insert into tb values (2);
insert into tb values (3);
insert into tb values (null);

select /*+ recompile */ * from tb where not a>1;

create index i_tb_a on tb(a);

select /*+ recompile */ * from tb where not a is not null;
select /*+ recompile */ * from tb where not a is null;
select /*+ recompile */ * from tb where not a>1;
select /*+ recompile */ * from tb where not a<1;

select /*+ recompile */ * from tb where not a<=>null;
select /*+ recompile */ * from tb where a<>null;

drop table tb;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
