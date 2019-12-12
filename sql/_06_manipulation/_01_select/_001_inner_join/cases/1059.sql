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
--Test join with list partitioned table and heap table
create class dept (
    deptno integer not null, 
    dname varchar(20),
    loc  varchar(30)
)
partition by list (loc)(
   partition area1 values in ('NEW YORK'),
   partition area2 values in ('DALLAS'),
   partition area3 values in ('CHICAGO'),
   partition area4 values in ('BOSTON'));

  
create table EMP
(
  EMPNO    integer not null,
  ENAME    VARCHAR(10),
  loc      varchar(30)
);

insert into dept values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept values(20, 'RESEARCH', 'DALLAS');
insert into dept values(30, 'SALES', 'CHICAGO');
insert into dept values(40, 'OPERATIONS', 'BOSTON');
insert into dept values(10, 'ACCOUNTING', 'NEW YORK');
insert into dept values(20, 'RESEARCH', 'DALLAS');
insert into dept values(30, 'SALES', 'CHICAGO');
insert into dept values(40, 'OPERATIONS', 'BOSTON');


insert into emp values(7369, 'SMITH', 'NEW YORK');
insert into emp values(7499, 'ALLEN', 'DALLAS');
insert into emp values(7521, 'WARD',  'CHICAGO');
insert into emp values(7566, 'JONES', 'BOSTON');
insert into emp values(7654, 'MARTIN', 'NEW YORK');
insert into emp values(7698, 'BLAKE',  'DALLAS');
insert into emp values(7782, 'CLARK',  'CHICAGO');
insert into emp values(7839, 'KING',  'BOSTON');
insert into emp values(7788, 'SCOTT',  'BOSTON');
insert into emp values(7744, 'TURNER ',  'DALLAS');
insert into emp values(7744, 'TURNER ',  null);
insert into emp values(7744, 'TURNER ',  null);

select e.empno, e.ename, e.loc, d.dname
from   emp e inner join dept d 
on     e.loc = d.loc order by 1;

drop class emp;
drop class dept;
