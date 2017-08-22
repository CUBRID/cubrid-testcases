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
--Insert into data using subquery
CREATE TABLE T1 ( 
  col1     int    NOT NULL, 
  col2      VARCHAR(20), 
  col3       VARCHAR(25),
  col4           VARCHAR(25),
  col5    VARCHAR(20), 
  col6       DATE,
  col7          VARCHAR(10),
  col8          numeric(8,2), 
  col9  numeric(2,2), 
  col10      int, 
  col11   int  );

CREATE TABLE T2 ( 
  col1     int    NOT NULL, 
  col3       VARCHAR(25),
  col4           VARCHAR(25),
  col5    VARCHAR(20), 
  col6       DATE,
  col7          VARCHAR(10),
  col8          numeric(8,2), 
  col11   int,
  col12    numeric(9,2),
  col13    numeric(6,2)  );

insert into T1 values (100,'Steven','King','SKING','515.123.4567','06/17/1987','AD_PRES',24000,null,null,90);
insert into T1 values (101,'Neena','Kochhar','NKOCHHAR','515.123.4568','09/21/1989','AD_VP',17000,null,100,90);
insert into T1 values (102,'Lex','De Haan','LDEHAAN','515.123.4569','01/13/1993','AD_VP',17000,null,100,90);
insert into T1 values (103,'Alexander','Hunold','AHUNOLD','590.423.4567','01/03/1990','IT_PROG',9000,null,102,60);
insert into T1 values (104,'Bruce','Ernst','BERNST','590.423.4568','05/21/1991','IT_PROG',6000,null,103,60);
insert into T1 values (105,'David','Austin','DAUSTIN','590.423.4569','06/25/1997','IT_PROG',4800,null,103,60);
insert into T1 values (106,'Valli','Pataballa','VPATABAL','590.423.4560','02/05/1998','IT_PROG',4800,null,103,60);
insert into T1 values (107,'Diana','Lorentz','DLORENTZ','590.423.5567','02/07/1999','IT_PROG',4200,null,103,60);
insert into T1 values (108,'Nancy','Greenberg','NGREENBE','515.124.4569','08/17/1994','FI_MGR',12000,null,101,100);


insert into T2 (col1, col3, col4, col5,col6,col7, col8, col11)
select  col1, col3, col4, col5,col6,col7, col8, col11 from T1;

drop class T1;
drop class T2;