--+ holdcas on;
create table tb (a int, b varchar(10));
insert into tb values (1,'A');
insert into tb values (2,'B');
insert into tb values (3,'C');
create index  i_tb_a on tb(a);

select /*+ RECOMPILE */ a from tb where a>0 using index i_tb_a(+) keylimit 1,4 order by a asc for orderby_num()<2;
drop table tb;

commit;
--+ holdcas off;
