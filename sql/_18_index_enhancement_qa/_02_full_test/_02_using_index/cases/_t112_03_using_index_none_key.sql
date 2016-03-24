--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(col1 int, col2 varchar(100), col3 DATE, col4 MONETARY, col5 float, col6 char(1));

create index idx_t1_col1 on t1(col1);
create index idx_t1_col2 on t1(col2);

--TEST
create index NoNE on t1(col3);

--TEST
create index "NoNE" on t1(col4);

--TEST
create index "NoNE index" on t1(col6);

insert into t1 values (1,'basket', DATE('2010-10-28'), 1, 1.1, 'Y');
insert into t1 values (2,'football', DATE('2010-10-28'), 1, 1.2, 'N');

--TEST
select /*+ RECOMPILE */ col4 from t1 where col4 >=0 using index t1.NoNE;

--TEST
select /*+ RECOMPILE */ col4 from t1 where col4 >=0 using index t1."NoNE";

--TEST
select /*+ RECOMPILE */ col6 from t1 where col6 >='' using index t1."NoNE index";

drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
