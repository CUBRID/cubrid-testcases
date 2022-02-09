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
--[er]Use orderby_num() in query without between and statement
create class T1
(
  EMPNO    integer not null,
  ENAME    VARCHAR(10),
  JOB      VARCHAR(9),
  MGR      integer,
  TESTDATE DATE,
  S1      integer,
  COMM     integer,
  DEPTNO   integer
);

insert into T1 values(7369, 'SMITH', 'CLERK',7902, date'12/17/1980',800.00,null,20);
insert into T1 values(7499, 'ALLEN', 'SALESMAN',7698, date'02/20/1981',1600.00,300.00,30);
insert into T1 values(7521, 'WARD',  'SALESMAN',7698, date'02/22/1981',1250.00,500.00,30);
insert into T1 values(7566, 'JONES', 'MANAGER', 7839, date'04/02/1981',2975.00,null, 20);
insert into T1 values(7654, 'MARTIN', 'SALESMAN',7698,date'09/28/1981',1250.00,1400.00,30);
insert into T1 values(7698, 'BLAKE',  'MANAGER',7839, date'05/01/1981',2850.00,null,30);
insert into T1 values(7782, 'CLARK',  'MANAGER',7839, date'06/09/1981',2450.00,null,10);
insert into T1 values(7839, 'KING',  'PRESIDENT',NULL, date'11/17/1981',5000.00,null,10);
insert into T1 values(7788, 'SCOTT',  'ANALYST',7566, date'04/19/1987',3000.00,null,20);
insert into T1 values(7744, 'TURNER ',  'SALESMAN ',7698, date'09/08/1981',1500.00,null,10);

select empno, ename, job from T1 
where S1 > 1800
order by S1 for orderby_num() <> 0;

drop class T1;
