drop class if exists t1;
drop class if exists dept;

create table DEPT (
  DEPTNO integer primary key,
  DNAME  VARCHAR(14)
);

create table t1
(
  EMPNO    integer primary key,
  ENAME    VARCHAR(10),
  JOB      VARCHAR(9),  
  DEPTNO   integer,
  constraint FK_DEPTNO foreign key (DEPTNO) references DEPT (DEPTNO)
);

insert into dept values(20, 'RESEARCH');

insert into t1 values(7369, 'SMITH', 'CLERK',20);

create unique index i_online_empno on t1(EMPNO) with online;

SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where class_name = 't1' order by 1,2,3;

--@queryplan
select /*+ recompile */ * from t1 where EMPNO > 0 using index i_online_empno(+);

--@queryplan
select /*+ recompile */ * from t1 where EMPNO > 0 using index pk_t1_empno(+);

--@queryplan
select /*+ recompile */ * from t1 where EMPNO > 0;

drop class t1;
drop class dept;
