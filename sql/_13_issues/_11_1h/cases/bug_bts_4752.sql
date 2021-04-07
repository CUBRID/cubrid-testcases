--+ holdcas on;

create table tb (id int primary key, a short);
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);
create index i_tb_a on tb(a);
--should use index i_tb_a as covering index. 
select /*+ recompile */ a from tb where a between 2 and 3;


drop table tb;

create table tb (id int primary key, a FLOAT);
create index i_tb_a on tb(a);
insert into tb values (1,-1.1);
insert into tb values (2,0);
insert into tb values (3,0.01);
insert into tb values (4,1.013);
-- expect using covering index i_tb_a
select /*+ recompile */ a from tb where a between 0 and 1.013;


drop table tb;

commit;

--+ holdcas off;

