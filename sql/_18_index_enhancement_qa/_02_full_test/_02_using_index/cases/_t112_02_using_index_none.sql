--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(col1 int, col2 varchar(100), col3 DATE, col4 MONETARY, col5 float, col6 char(1));
create table t2(col1 int, col2 varchar(100), col3 DATE, col4 MONETARY, col5 float, col6 char(1));

create index idx_t1_col1 on t1(col1);
create index idx_t1_col2 on t1(col2);

create index idx_t2_col1 on t2(col1);
create index idx_t2_col2 on t2(col2);
create index idx_t2_col3 on t2(col3);
create index idx_t2_col4 on t2(col4);
create index idx_t2_col5 on t2(col5);
create index idx_t2_col6 on t2(col6);

insert into t1 values (1,'basket', DATE('2010-10-28'), 1, 1.1, 'Y');
insert into t1 values (2,'football', DATE('2010-10-28'), 1, 1.2, 'N');

insert into t2 values (3,'basket-t2', DATE('2010-10-28'), 1, 1.1, 'Y');
insert into t2 values (4,'football-t2', DATE('2010-10-28'), 1, 1.2, 'N');


--TEST
select /*+ RECOMPILE */ col5 from t2 where col5>0 order by 1;

--TEST
select /*+ RECOMPILE */ col5 from t2 where col5>0 using index t2.none order by 1;

--TEST
select /*+ RECOMPILE */ col5 from t2 where col5>0 using index t2.idx_t2_col5,t2.none order by 1;

--TEST
select /*+ RECOMPILE */ col5 from t2 where col5>0 using index t2.idx_t2_col5 keylimit 1,1,t2.none order by 1;

--TEST
select /*+ RECOMPILE */ col5 from t2 where col5>0 using index t2.idx_t2_col5 keylimit 2,1,t2.none order by 1;

--TEST
select /*+ RECOMPILE */ col5 from t2 where col5>0 using index t2.none,t2.idx_t2_col5  order by 1;

--TEST
select /*+ RECOMPILE */ t1.col1,t2.col2 from t1,t2 where t1.col1>0 and t2.col2>'' using index t1.none, t2.none  order by 1,2;

--TEST
select /*+ RECOMPILE */ t1.col1,t2.col2 from t1,t2 where t1.col1>0 and t2.col2>'' using index t1.idx_t1_col1, t2.none  order by 1,2;

--TEST
select /*+ RECOMPILE */ t1.col1,t2.col2 from t1,t2 where t1.col1>0 and t2.col2>'' using index t1.none, t2.idx_t2_col2  order by 1,2;

--TEST
select /*+ RECOMPILE */ t1.col1,t2.col2 from t1,t2 where t1.col1>0 and t2.col2>'' using index t1.none, t2.idx_t2_col2,t2.none order by 1,2;

--TEST
select /*+ RECOMPILE */ t1.col1,t2.col2 from t1,t2 where t1.col1>0 and t2.col2>'' using index t1.none,t1.idx_t1_col1, t2.idx_t2_col2,t2.none order by 1,2;

--TEST
update t1 set col6='N' where col1=1 using index t1.none;

--TEST
update t2 set col6='N' where col1=3 using index t2.idx_t2_col1,t2.none;

--TEST
update t2 set col6='X' where col1=3 using index t2.none, t2.idx_t2_col1;

insert into t2 values (5,'basket-t2', DATE('2010-10-28'), 1, 1.1, 'Y');
insert into t2 values (6,'football-t2', DATE('2010-10-28'), 1, 1.2, 'N');
insert into t2 values (7,'football-t2', DATE('2010-10-28'), 1, 1.2, 'N');

--TEST 
delete from t2 where col1=5 using index t2.none;

--TEST 
delete from t2 where col1=6 using index t2.idx_t2_col1,t2.none;

--TEST 
delete from t2 where col1=7 using index t2.none, t2.idx_t2_col1;


drop table t1,t2;


set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
