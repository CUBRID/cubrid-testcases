--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1 (id int, v varchar(20), c char(20), s string);
create index i_t1_all on t1(v,c,s) with online;
create index i_t1_v on t1(v) with online;
create index i_t1_c on t1(c) with online;
create index i_t1_s on t1(s) with online;

insert into t1 values (1, 'dbms qa1 part', 'dbms qa1 part', 'dbms qa1 part');
insert into t1 values (2, 'dbms qa2 part', 'dbms qa2 part', 'dbms qa2 part');
insert into t1 values (3, 'dbms qa2 part', 'dbms qa2 part', 'dbms qb2 part');
insert into t1 values (4, 'aaa', 'aaa', 'aaa');
insert into t1 values (5, 'bbb', 'bbb', 'bbb');
insert into t1 values (6, 'ccc', 'ccc', 'ccc');
insert into t1 values (7, '', '', '');
insert into t1 values (8, ' ', ' ', ' ');
insert into t1 values (9, '  ', '  ', '  ');
insert into t1 values (10, null, null, null);


select /*+ recompile */ * from t1 where v like 'dbms qa%' order by v desc;

prepare stmt from 'select /*+ recompile */ * from t1 where v like ?||''%'' order by v desc;'
execute stmt using 'dbms qa'
deallocate prepare stmt;

drop table t1;

set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
