-- This testcase use modified Oracle samples. See below for the license:
-- Copyright (c) 2015 Oracle
-- Permission is hereby granted, free of charge, to any person obtaining a copy
--  of this software and associated documentation files (the "Software"), to deal
--  in the Software without restriction, including without limitation the rights
--  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
--  copies of the Software, and to permit persons to whom the Software is
--  furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all
--  copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
--  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
--  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
--  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
--  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
--  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
--  SOFTWARE.
create table select2_dept(
  DEPTNO clob,
  DNAME  VARCHAR(14),
  LOC    VARCHAR(13)
);

create table select2_emp(
  EMPNO    integer not null,
  ENAME    VARCHAR(10),
  JOB      VARCHAR(9),
  MGR      integer,
  HIREDATE DATE,
  SAL      integer,
  COMM     integer,
  DEPTNO   clob
);

insert into select2_dept values(char_to_clob('10'), 'ACCOUNTING', 'NEW YORK');
insert into select2_dept values(char_to_clob('20'), 'RESEARCH', 'DALLAS');
insert into select2_dept values(char_to_clob('30'), 'SALES', 'CHICAGO');
insert into select2_dept values(char_to_clob('40'), 'OPERATIONS', 'BOSTON');

insert into select2_emp values(7369, 'SMITH', 'CLERK',7902, date'12/17/1980',800.00,null,char_to_clob('20'));
insert into select2_emp values(7499, 'ALLEN', 'SALESMAN',7698, date'02/20/1981',1600.00,300.00,char_to_clob('30'));
insert into select2_emp values(7521, 'WARD',  'SALESMAN',7698, date'02/22/1981',1250.00,500.00,char_to_clob('30'));
insert into select2_emp values(7566, 'JONES', 'MANAGER', 7839, date'04/02/1981',2975.00,null, char_to_clob('20'));
insert into select2_emp values(7654, 'MARTIN', 'SALESMAN',7698,date'09/28/1981',1250.00,1400.00,char_to_clob('30'));
insert into select2_emp values(7698, 'BLAKE',  'MANAGER',7839, date'05/01/1981',2850.00,null,char_to_clob('30'));
insert into select2_emp values(7782, 'CLARK',  'MANAGER',7839, date'06/09/1981',2450.00,null,char_to_clob('10'));
insert into select2_emp values(7839, 'KING',  'PRESIDENT',NULL, date'11/17/1981',5000.00,null,char_to_clob('10'));
insert into select2_emp values(7788, 'SCOTT',  'ANALYST',7566, date'04/19/1987',3000.00,null,char_to_clob('20'));
insert into select2_emp values(7744, 'TURNER ',  'SALESMAN ',7698, date'09/08/1981',1500.00,null,char_to_clob('10'));

-- INNER JOIN
select ename,job, dname from select2_emp inner join select2_dept on clob_to_char(select2_dept.deptno)=clob_to_char(select2_emp.deptno) order by 1,2;
-- LEFT OUTER JOIN
select ename,job, dname from select2_emp LEFT OUTER JOIN select2_dept on clob_to_char(select2_dept.deptno)=clob_to_char(select2_emp.deptno) order by 1,2;
-- RIGHT OUTER JOIN
select /*+ USE_MERGE */ ename,job, dname from select2_emp RIGHT OUTER JOIN select2_dept on clob_to_char(select2_dept.deptno)=clob_to_char(select2_emp.deptno) order by 1,2;
select /*+ USE_NL */ ename,job, dname from select2_emp RIGHT OUTER JOIN select2_dept on clob_to_char(select2_dept.deptno)=clob_to_char(select2_emp.deptno) order by 1,2;

delete from select2_emp;
delete from select2_dept;
drop class select2_emp;
drop class select2_dept;
