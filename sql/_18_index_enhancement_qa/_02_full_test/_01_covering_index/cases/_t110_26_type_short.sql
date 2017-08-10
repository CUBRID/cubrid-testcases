--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table tb (id int primary key, a short);
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);
create index i_tb_a on tb(a);
select /*+ recompile */ a from tb where a between 2 and 3;
drop table tb;

create table tb (id int primary key, a int);
insert into tb values (1,1);
insert into tb values (2,2);
insert into tb values (3,3);
create index i_tb_a on tb(a);

select /*+ recompile */ a from tb where a between 2 and 3;
drop table tb;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
