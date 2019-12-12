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
--test like with to_char function to transfer
create class test
(
  TESTNO    integer not null,
  ENAME    VARCHAR(10),
  WORKS     SET VARCHAR(9),
  TESTDATE  date);
  
insert into test values(7369, 'SMITH', {'A','B','C'},date'05/21/2008');
insert into test values(7369, 'SMITH1', {'B','C','A'},date'04/21/2008');
insert into test values(7379, 'JERRY', {'A','B','C','1'},date'03/21/2008');
insert into test values(7499, 'ALLEN', {'X','Y','Z'}, null);
insert into test values(7521, 'WARD', {'D','E','F'},null);
insert into test values(7566, 'JONES',{'L','M','N'},null);

select * from test
where to_char(testdate) like '05%';


drop class test;