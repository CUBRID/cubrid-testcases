--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (id int primary key, a int);
insert into tb values (4,4);
insert into tb values (1,1);
create index i_tb_a on tb(a) with online;
insert into tb values (2,2);
insert into tb values (3,3);

create table ta (id int primary key, a int);
insert into ta values (4,4);
insert into ta values (1,1);
create index i_ta_a on ta(a) with online;
insert into ta values (2,2);
insert into ta values (3,3);

--TEST
select /*+ recompile */ ta.a,tb.a from ta,tb where ta.a between 1 and 2 and tb.a between 3 and 4 order by ta.a desc, tb.a desc limit 10; 
--TEST
select /*+ recompile */ ta.a,tb.a from ta,tb where ta.a between 1 and 2 order by ta.a desc, tb.a desc; 
--TEST
select /*+ recompile */ ta.a,tb.a from ta left join tb on ta.id=tb.id where ta.a between 1 and 2 order by ta.a desc; 
--TEST
select /*+ recompile */ ta.a from ta where ta.a between 1 and 2 and exists (select tb.a from tb where tb.a between 3 and 4 order by tb.a desc) order by ta.a desc limit 10; 

drop table ta,tb;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
