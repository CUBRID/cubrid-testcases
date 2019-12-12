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
create table aoo(a int, b blob);
insert into aoo values(1, bit_to_blob(1));
insert into aoo values(1, bit_to_blob('1'));
insert into aoo values(1, bit_to_blob(notexistattributesxxx));
insert into aoo values(1, bit_to_blob(x'ff'));
select blob_to_bit(a) from aoo order by 1;
select blob_to_bit(b) from aoo order by 1;
select blob_length(b) from aoo order by 1;
select blob_length('a') from aoo order by 1;

create table aoo2(a int, c clob);
insert into aoo2 values(1, char_to_clob(1));
insert into aoo2 values(1, char_to_clob('1'));
insert into aoo2 values(1, char_to_clob(notexistattributesxxx));
insert into aoo2 values(1, char_to_clob(x'ff'));
select clob_to_char(a) from aoo2 order by 1;
select clob_to_char(c) from aoo2 order by 1;
select clob_length(c) from aoo2 order by 1;
select clob_length(1) from aoo2 order by 1;

delete from aoo;
delete from aoo2;

drop aoo;
drop aoo2;

create table  dept(
  DEPTNO int,
  DNAME  VARCHAR(14),
  LOC    VARCHAR(13)
);

create table  emp(
  EMPNO    integer not null,
  ENAME    VARCHAR(10),
  JOB      VARCHAR(9),
  MGR      integer,
  HIREDATE DATE,
  SAL      integer,
  COMM     integer,
  DEPTNO   int
);

select ename,job, dname from  emp inner join  dept on dept.deptno=emp.deptno order by 1,2;
select ename,job, dname from  emp, dept where clob_to_char( dept.deptno)=clob_to_char( emp.deptno) order by 1,2;
select ename,job, dname from  emp inner join  dept on clob_to_char( dept.deptno)=clob_to_char( emp.deptno) order by 1,2;
select ename,job, dname from  emp LEFT OUTER JOIN  dept on clob_to_char( dept.deptno)=clob_to_char( emp.deptno) order by 1,2;
select ename,job, dname from emp RIGHT OUTER JOIN dept on clob_to_char(dept.deptno)=clob_to_char(emp.deptno) order by 1,2; 

drop emp;
drop dept;
