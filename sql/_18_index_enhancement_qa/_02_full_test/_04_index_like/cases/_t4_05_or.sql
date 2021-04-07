--+ holdcas on;
create table t1 (id int, v varchar(20), c char(20), s string);
create index i_t1_all on t1(v,c,s);
create index i_t1_v on t1(v);
create index i_t1_c on t1(c);
create index i_t1_s on t1(s);

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

select /*+ recompile */ * from t1 where v like 'c%' or v < 'c';
select /*+ recompile */ * from t1 where c like 'c%' or c < 'c';
select /*+ recompile */ * from t1 where s like 'c%' or s < 'c';

select /*+ recompile */ * from t1 where v like 'dbms qa1%' or v is null;
select /*+ recompile */ * from t1 where c like 'dbms qa1%' or c is null;
select /*+ recompile */ * from t1 where s like 'dbms qa1%' or s is null;

select /*+ recompile */ * from t1 where v like 'dbms qa1%' or v like 'dbms qa2%';
select /*+ recompile */ * from t1 where c like 'dbms qa1%' or c like 'dbms qa2%';
select /*+ recompile */ * from t1 where s like 'dbms qa1%' or s like 'dbms qa2%';

select /*+ recompile */ * from t1 where v like 'dbms qa1%' or c like 'dbms qa2%' or s like 'dbms qa2%';
select /*+ recompile */ * from t1 where v like 'dbms qa1%' or c like 'dbms qa2%' or s like 'dbms qa2%';



drop table t1;
commit;
--+ holdcas off;
