--+ holdcas on;

create table ta (id int primary key, a int);
insert into ta values (4,4);
insert into ta values (1,1);
create index i_ta_a on ta(a);
insert into ta values (2,2);
insert into ta values (3,3);

create table tb (id int primary key, a int);
insert into tb values (4,4);
insert into tb values (1,1);
create index i_tb_a on tb(a);
insert into tb values (2,2);
insert into tb values (3,3);

--We expect table tb adopt DESC INDEX SCAN and optimize ORDER BY
select /*+ recompile */ ta.a,tb.a from ta,tb where ta.a between 1 and 2 and tb.a between 3 and 4 order by ta.a desc, tb.a desc;


drop table ta;
drop table tb;

commit;

--+ holdcas off;

