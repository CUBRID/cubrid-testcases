--+ holdcas on;

set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (id int, v varchar(20), c char(20), s string);
create index i_t1_all on t1(v desc);

insert into t1 values (1, 'dbms qa1 part', 'dbms qa1 part', 'dbms qa1 part');
insert into t1 values (2, 'dbms qa2 part', 'dbms qa2 part', 'dbms qa2 part');
insert into t1 values (3, 'dbms qa3 part', 'dbms qa2 part', 'dbms qb2 part');

select /*+ recompile use_desc_idx*/ * from t1 where v is not null order by v desc;

drop table t1;


create table tb (id int primary key, a int);

insert into tb values (1, 1);
insert into tb values (2, 2);
insert into tb values (3, 3);
insert into tb values (4, 4);
create reverse index ir_tb_a on tb(a);
--Expect desc order
select /*+ recompile use_desc_idx */ * from tb where a>0 order by a desc;


drop table tb;
set  system parameters 'dont_reuse_heap_file=no';

commit;

--+ holdcas off;

