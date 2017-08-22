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
CREATE TABLE t1(id int);
CREATE TABLE t2(id int,a int);

insert into t1 values (1);
insert into t2 values (1,1);

-- 1 tuple
select * FROM t1 WHERE id in (SELECT id FROM t2);

-- 1 tuple
select * FROM t1 WHERE id in (SELECT id FROM t2 ORDER BY a);

drop table t1;
drop table t2;




CREATE TABLE a (col INTEGER);
create table b (col1 int, col2 int);
INSERT INTO a VALUES (1);
INSERT INTO a VALUES (2);

INSERT INTO b VALUES (2, 20);
INSERT INTO b VALUES (3, 30);

SELECT col FROM a WHERE col IN (SELECT * FROM b);
-- ERROR: Only one column can be specified in the select list when the subquery is not introduced with EXISTS.

SELECT col FROM a WHERE col NOT IN (SELECT * FROM b);
-- ERROR: Only one column can be specified in the select list when the subquery is not introduced with EXISTS.

select * from a where (select 1, 2 from b) not in (select 4, 5 from b);
-- ERROR: Only one column can be specified in the select list when the subquery is not introduced with EXISTS.

drop table a;
drop table b;



create table EMP ( EMPNO integer not null, ENAME VARCHAR(10), JOB VARCHAR(9), MGR integer, TEST_DATE DATE, SAL integer, COMM integer, DEPTNO integer );
insert into emp values(7369, 'SMITH', 'CLERK',7902, '12/17/1980',800.00,null,20);
insert into emp values(7499, 'ALLEN', 'SALESMAN',7698, '02/20/1981',1600.00,300.00,30);
insert into emp values(7521, 'WARD', 'SALESMAN',7698, '02/22/1981',1250.00,500.00,30);
insert into emp values(7566, 'JONES', 'MANAGER', 7839, '04/02/1981',2975.00,null, 20);
insert into emp values(7654, 'MARTIN', 'SALESMAN',7698,'09/28/1981',1250.00,1400.00,30);
insert into emp values(7698, 'BLAKE', 'MANAGER',7839, '05/01/1981',2850.00,null,30);
insert into emp values(7782, 'CLARK', 'MANAGER',7839, '06/09/1981',2450.00,null,10);
insert into emp values(7839, 'KING', 'PRESIDENT',NULL, '11/17/1981',5000.00,null,10);
insert into emp values(7788, 'SCOTT', 'ANALYST',7566, '04/19/1987',3000.00,null,20);
insert into emp values(7744, 'TURNER ', 'SALESMAN ',7698, '09/08/1981',1500.00,null,10);

select * from emp where (empno) in (select empno from emp where sal > 2000 or comm is null) order by 1,2;
-- success

select * from emp where (ename ) in (select ename from emp where sal > 2000 or comm is null) order by 1,2;
-- success

select * from emp where (empno, ename ) in (select empno, ename from emp where sal > 2000 or comm is null) order by 1,2;
-- ERROR: Only one column can be specified in the select list when the subquery is not introduced with EXISTS.

drop table EMP;
 


