--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (a int, b varchar(10));
insert into tb values (1,'A');
insert into tb values (2,'B');
insert into tb values (3,'C');
create index  i_tb_a on tb(a);

select * from tb where a>0 using index tb.none keylimit 2,3;

drop table tb;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
