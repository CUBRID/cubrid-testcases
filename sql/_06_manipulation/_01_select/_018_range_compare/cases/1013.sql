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
--Test compare operator with list or sequence

create class emp
(
  EMPNO    integer not null,
  ENAME    VARCHAR(10),
  WORKS    list VARCHAR(9));
  
insert into emp values(7369, 'SMITH', {'A','B','C','A'});
insert into emp values(7349, 'SMITH1', {'B','C','A','A'});
insert into emp values(7379, 'JERRY', {'A','B','C','B'});
insert into emp values(7379, 'JERRY', {'A','B','C','1'});
insert into emp values(7499, 'ALLEN', {'X','Y','Z'});
insert into emp values(7521, 'WARD', {'D','E','F'});
insert into emp values(7566, 'JONES',{'L','M','N'});

select * from emp 
where works > {'A','B','C','A'} order by 1;

select * from emp 
where works < {'A','B','C','A'} order by 1;

select * from emp 
where works = {'A','B','C','A'} order by 1;

select * from emp 
where works <> {'A','B','C','A'} order by 1;


drop class emp;
