--Test join with subclass 
create class t2 (name varchar(10), deptno integer);


create class DEPT
(
  DEPTNO integer not null,
  DNAME  VARCHAR(14),
  LOC    VARCHAR(13)
);

  
create class t1 as subclass of t2
(
  EMPNO    integer not null,
  JOB      VARCHAR(9),
  MGR      integer,
  testdate DATE,
  s1      integer,
  COMM     integer
);

insert into dept values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept values(20, 'RESEARCH', 'DALLAS');
insert into dept values(30, 'SALES', 'CHICAGO');
insert into dept values(40, 'OPERATIONS', 'BOSTON');

insert into t2 values ('JERRY', 10);
insert into t2 values ('NACNY', 20);
insert into t2 values ('TOM', 30);
insert into t2 values ('KITTY', 40);

insert into t1 values('SMITH',20, 7369, 'CLERK',7902, date'12/17/1980',800.00,null);
insert into t1 values('ALLEN',30, 7499, 'SALESMAN',7698, date'02/20/1981',1600.00,300.00);
insert into t1 values('WARD', 30, 7521, 'SALESMAN',7698, date'02/22/1981',1250.00,500.00);
insert into t1 values('JONES',20, 7566, 'MANAGER', 7839, date'04/02/1981',2975.00,null);
insert into t1 values('CLARK',10, 7782, 'MANAGER',7839, date'06/09/1981',2450.00,null);

select t1.name, dept.loc from t1 inner join dept on t1.deptno=dept.deptno order by 1;

drop class dept;
drop class t1;
drop class t2;