--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb(a int,b char(1), c varchar(1), d date);
create index i_tb_a on tb(a);
create index i_tb_ab on tb(a,b);
create index i_tb_abc on tb(a,b,c);
create index i_tb_abcd on tb(a,b,c,d);
insert into tb values (1,'Y', 'Monday', DATE('2010-10-27'));
insert into tb values (2,'N', 'Friday', DATE('2010-10-28'));
insert into tb values (3,'Y', 'Monday', DATE('2010-10-29'));
insert into tb values (4,'N', 'Friday', DATE('2010-10-30'));

select /*+ recompile */ a from tb where a>0;
select /*+ recompile */ x.a,y.a from tb x,tb y where x.a>1 and y.a>1;
select /*+ recompile */ x.a,y.a from tb x,tb y where x.a=y.a and (x.a>1);


drop table tb;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
