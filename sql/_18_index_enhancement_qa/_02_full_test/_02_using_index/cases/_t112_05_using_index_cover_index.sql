--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(col1 int, col2 varchar(100), col3 DATE, col4 MONETARY, col5 float, col6 char(1));

create index idx_t1_col1 on t1(col1);
create index idx_t1_col2 on t1(col2);
create index idx_t1_all on t1(col1,col2,col3,col4,col5,col6);

insert into t1 values (1,'basket', DATE('2010-10-28'), 1, 1.1, 'Y');
insert into t1 values (2,'football', DATE('2010-10-28'), 1, 1.2, 'N');

--TEST: should not use index idx_t1_col1
select /*+ RECOMPILE */ col1 from t1 where col1>0 using index t1.none;

--TEST: should not use covering index idx_t1_col1
select /*+ RECOMPILE */ * from t1 where col1>0 using index t1.idx_t1_col1 keylimit 1,1;

--TEST: should not use index idx_t1_all
select /*+ RECOMPILE */ * from t1 where col1>0 using index t1.none keylimit 1,1;

drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
