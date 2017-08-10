--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table tb (a double );
create index i_tb_a on tb(log10(a));
insert into tb values (1);
insert into tb values (2);
insert into tb values (3);
insert into tb values (null);

--expect  index is used. In fact, it's fail.
select /*+ recompile */ * from tb where log10(a) is not null ;
-- index is used. Result is good.
select /*+ recompile */ * from tb where log10(a) >=0 ;

drop table tb;


set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
