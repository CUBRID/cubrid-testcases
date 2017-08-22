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
--+ holdcas on;
--Test not between predication 
CREATE TABLE test ( 
  test_ID     int    NOT NULL, 
  name1      VARCHAR(20), 
  name2       VARCHAR(25),
  name3           VARCHAR(25),
  number    VARCHAR(20), 
  testdate       DATE,
  id          VARCHAR(10),
  SS          numeric(8,2), 
  com  numeric(2,2), 
  mid      int, 
  did   int  );


insert into test values (100,'Steven','King','SKING','515.123.4567','06/17/1987','AD_PRES',24000,null,null,90);
insert into test values (101,'Neena','Kochhar','NKOCHHAR','515.123.4568','09/21/1989','AD_VP',17000,null,100,90);
insert into test values (102,'Lex','De Haan','LDEHAAN','515.123.4569','01/13/1993','AD_VP',17000,null,100,90);
insert into test values (103,'Alexander','Hunold','AHUNOLD','590.423.4567','01/03/1990','IT_PROG',9000,null,102,60);
insert into test values (104,'Bruce','Ernst','BERNST','590.423.4568','05/21/1991','IT_PROG',6000,null,103,60);
insert into test values (105,'David','Austin','DAUSTIN','590.423.4569','06/25/1997','IT_PROG',4800,null,103,60);
insert into test values (106,'Valli','Pataballa','VPATABAL','590.423.4560','02/05/1998','IT_PROG',4800,null,103,60);
insert into test values (107,'Diana','Lorentz','DLORENTZ','590.423.5567','02/07/1999','IT_PROG',4200,null,103,60);
insert into test values (108,'Nancy','Greenberg','NGREENBE','515.124.4569','08/17/1994','FI_MGR',12000,null,101,100);
insert into test values (109,'Daniel','Faviet','DFAVIET','515.124.4169','08/16/1994','FI_ACCOUNT',9000,null,108,100);
insert into test values (110,'John','Chen','JCHEN','515.124.4269','09/28/1997','FI_ACCOUNT',8200,null,108,100);


select name1||'.'||name2, did
from   test 
where  name1 
not between 'Nancy' and 'Valli' order by 1,2;
select name1||'.'||name2, did
from   test 
where  did not
between 60 and 90 order by 1,2;
select name1||'.'||name2, SS
from   test 
where  SS not between 10000 and 50000 order by 1,2;

set system parameters 'compat_mode=mysql';
set system parameters 'pipes_as_concat=yes';

select name1||'.'||name2, did
from   test 
where  name1 
not between 'Nancy' and 'Valli' order by 1,2;
select name1||'.'||name2, did
from   test 
where  did not
between 60 and 90 order by 1,2;
select name1||'.'||name2, SS
from   test 
where  SS not between 10000 and 50000 order by 1,2;

set system parameters 'pipes_as_concat=no';
set system parameters 'compat_mode=cubrid';

drop class test;
commit;
--+ holdcas off;
