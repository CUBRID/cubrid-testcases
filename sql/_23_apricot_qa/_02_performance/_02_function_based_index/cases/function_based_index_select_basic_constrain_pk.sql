--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table tb (a double primary key, b double);
create index i_tb_b on tb(log10(b));
create index i_tb_a on tb(log10(a));
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);
insert into tb values (4,null);
select /*+ recompile */ * from tb where log10(a) is null ;
select /*+ recompile */ * from tb where log10(b) is null or log10(b) is not null ;
select /*+ recompile */ b from tb where log10(b) >0 ;

drop table tb;


set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
