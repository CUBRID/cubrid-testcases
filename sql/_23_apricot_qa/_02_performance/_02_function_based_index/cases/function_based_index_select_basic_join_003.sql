--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
drop table if exists tb;
create table tb(a double,b char(1), c varchar(6), d date);
create index i_tb_a on tb(log10(a));
insert into tb values (1,'Y', 'Monday', DATE('2010-10-27'));
insert into tb values (2,'N', 'Friday', DATE('2010-10-28'));
insert into tb values (3,'Y', 'Monday', DATE('2010-10-29'));
insert into tb values (4,'N', 'Friday', DATE('2010-10-30'));

--test
select /*+ recompile */ a from tb where log10(a)=0 ;
--test
select /*+ recompile */ x.a,y.a from tb x,tb y where log10(x.a)>0 and log10(y.a)>0 ;
--test
select /*+ recompile */ x.a,y.a from tb x,tb y where log10(x.a)=log10(y.a) and (log10(x.a)>0) ;
--test
select /*+ recompile */ x.a,y.a from tb x,tb y where x.a=y.a and (log10(x.a)>0) ;
--test
select /*+ recompile */ x.a,y.a from tb x,tb y where x.a=log10(y.a) and (log10(x.a)>0) ;
--test
select /*+ recompile */ x.a,y.a from tb x,tb y where log10(x.a)=log10(y.a) and (x.a>0) ;
--test
select /*+ recompile */ x.a,y.a from tb x,tb y where log10(x.a)=y.a and (log10(x.a)>0) ;
--test
select /*+ recompile */ x.a,y.a from tb x,tb y where x.a=log10(y.a) and (x.a>1) ;
drop table tb;


set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
