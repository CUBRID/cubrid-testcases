--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(col1 int, col2 varchar(100), col3 DATE, col4 MONETARY, col5 float, col6 char(1));
create table t2(col1 int, col2 varchar(100), col3 DATE, col4 MONETARY, col5 float, col6 char(1));

create index idx_t1_col1 on t1(col1);
create index idx_t1_col2 on t1(col2);

create index idx_t2_col3 on t2(col3);
create index idx_t2_col4 on t2(col4);
create index idx_t2_col5 on t2(col5);
create index idx_t2_col6 on t2(col6);

insert into t1 values (1,'basket', DATE('2010-10-28'), 1, 1.1, 'Y');
insert into t1 values (2,'football', DATE('2010-10-28'), 1, 1.2, 'N');

insert into t2 values (3,'basket-t2', DATE('2010-10-28'), 1, 1.1, 'Y');
insert into t2 values (4,'football-t2', DATE('2010-10-28'), 1, 1.2, 'N');

--TEST
select /*+ RECOMPILE */ col1 from t1 where col1>0 using index t1.none keylimit 1,1;

--TEST
select /*+ RECOMPILE */ t1.col2, t2.col3 from t1,t2 where t1.col2>'' and t2.col3 is not null using index t1.none keylimit 1,1;

--TEST
select /*+ RECOMPILE */ t1.col2, t2.col3 from t1,t2 where t1.col2>'' and t2.col3 is not null using index t1.none, t2.none keylimit 1,1;

--TEST
select /*+ RECOMPILE */ t1.col2, t2.col3 from t1,t2 where t1.col1>0 and t2.col3 is not null using index t1.none keylimit 1,1, t2.none keylimit 1,1;

drop table t1,t2;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
