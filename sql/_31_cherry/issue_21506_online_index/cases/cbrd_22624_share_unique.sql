drop table if exists EMP;
drop class if exists DEPT;

create table DEPT (
  DEPTNO integer primary key,
  DNAME  VARCHAR(14)
);

create table EMP
(
  EMPNO    integer,
  ENAME    VARCHAR(10),
  JOB      VARCHAR(9),  
  DEPTNO   integer,
  constraint FK_DEPTNO foreign key (DEPTNO) references DEPT (DEPTNO)
);
    
insert into dept values(20, 'RESEARCH');
insert into EMP values(7369, 'SMITH', 'CLERK',20);

create unique index i_online_empno_a on EMP (EMPNO) with online;

--test: cub_server crashed:
create unique index i_online_empno_b on EMP(EMPNO) with online;

SELECT index_name, is_unique, is_reverse, class_name, owner_name, key_count, is_primary_key, is_foreign_key, filter_expression, have_function, comment, status FROM db_index where class_name = 'emp' order by 1,2,3;

--@queryplan
select /*+ recompile */ * from emp where EMPNO > 0 using index i_online_empno_a(+);

--@queryplan
select /*+ recompile */ * from emp where EMPNO > 0 using index i_online_empno_b(+);

--@queryplan
select /*+ recompile */ * from emp where EMPNO > 0;

drop table EMP;
drop table DEPT;

