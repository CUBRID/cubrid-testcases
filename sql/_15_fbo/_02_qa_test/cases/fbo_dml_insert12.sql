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
--insert with query and subquery

create class insert12_emp
(
  insert12_empNO    integer not null,
  ENAME    VARCHAR(10),
  JOB      VARCHAR(9),
  MGR      integer,
  HIREDATE DATE,
  SAL      integer,
  COMM     integer,
  DEPTNO   integer,
  ORDER_NO integer,
  BB       blob,
  CC       clob
);
insert into insert12_emp values(7369, 'SMITH', 'CLERK',7902, date'12/17/1980',800.00,null,20,1, bit_to_blob(X'0101'), char_to_clob('aaaaa'));
insert into insert12_emp values(7499, 'ALLEN', 'SALESMAN',7698, date'02/20/1981',1600.00,300.00,30,2, bit_to_blob(X'0111'), char_to_clob('bbbbb'));
insert into insert12_emp values(7521, 'WARD',  'SALESMAN',7698, date'02/22/1981',1250.00,500.00,30,3, bit_to_blob(X'11101'), char_to_clob('ccccc'));
insert into insert12_emp values(7566, 'JONES', 'MANAGER', 7839, date'04/02/1981',2975.00,null, 20,4, bit_to_blob(X'10101'), char_to_clob('ddddd'));
insert into insert12_emp values(7654, 'MARTIN', 'SALESMAN',7698,date'09/28/1981',1250.00,1400.00,30,5, bit_to_blob(X'01001'), char_to_clob('eeeee'));
insert into insert12_emp values(7698, 'BLAKE',  'MANAGER',7839, date'05/01/1981',2850.00,null,30,6, bit_to_blob(X'01010'), char_to_clob('fffff'));
insert into insert12_emp values(7782, 'CLARK',  'MANAGER',7839, date'06/09/1981',2450.00,null,10,7, bit_to_blob(X'01001'), char_to_clob('ggggg'));
insert into insert12_emp values(7839, 'KING',  'PRESIDENT',NULL, date'11/17/1981',5000.00,null,10,8, bit_to_blob(X'010101'), char_to_clob('hhhhh'));
insert into insert12_emp values(7788, 'SCOTT',  'ANALYST',7566, date'04/19/1987',3000.00,null,20,9, bit_to_blob(X'11110101'), char_to_clob('iiiii'));
insert into insert12_emp values(7744, 'TURNER ',  'SALESMAN ',7698, date'09/08/1981',1500.00,null,10,10, bit_to_blob(X'01101011'), char_to_clob('jjjjj'));

--insert with query
insert into insert12_emp select insert12_empno,ename,job,mgr,hiredate,sal,comm,deptno, order_no+10, bb, cc from insert12_emp where comm is null order by order_no asc;
insert into insert12_emp select insert12_empno,ename,job,mgr,hiredate,sal,comm,deptno, order_no+10, bb, cc from insert12_emp where blob_to_bit(bb)=X'01001';
insert into insert12_emp select insert12_empno,ename,job,mgr,hiredate,sal,comm,deptno, order_no+10, bb, cc from insert12_emp where clob_to_char(cc)='ggggg';

--insert with subquery
insert into insert12_emp (insert12_empno, ename, bb, cc) values(select insert12_empno from insert12_emp where rownum=25, 'Jack', bit_to_blob(X'0100111'), char_to_clob('added'));
insert into insert12_emp (insert12_empno, ename, bb, cc) values(1234, select ename from insert12_emp where rownum=30, bit_to_blob(B'10101'), char_to_clob('jjjjj'));

select insert12_empno,ename,job,mgr,hiredate,sal,comm,deptno,order_no,blob_to_bit(bb),clob_to_char(cc) from insert12_emp order by order_no asc;

delete from insert12_emp;
drop class insert12_emp;

