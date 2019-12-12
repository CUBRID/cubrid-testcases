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
drop table if exists port_weeklydailypricesTest,tmp;
create table port_weeklydailypricesTest(co_code varchar,start_dtm varchar,end_dtm varchar);
create table tmp(i int,j datetime,k datetime);
insert into tmp select 1,current_datetime,current_datetime+1;
insert into tmp select 2,current_datetime,current_datetime+2;
insert into tmp select 3,current_datetime,current_datetime+3;
INSERT INTO port_weeklydailypricesTest (co_code,start_dtm,end_dtm)
   SELECT * FROM
        (
            WITH CTE(co_code, start_dtm, end_dtm,n) AS
            (
                SELECT i,j,k,1
                FROM   tmp
                GROUP BY i
                UNION ALL
                SELECT  co_code     ,
                start_dtm,end_dtm,n+1
                FROM    CTE
                WHERE   CAST(end_dtm AS DATE) <= TO_DATE(SYSDATE+1) and n<5
             )
            SELECT co_code,start_dtm,end_dtm 
            FROM CTE
        );
drop table if exists port_weeklydailypricesTest,tmp;


drop table if exists x;
create table x(a int,b int,c int,d int,e int);
insert into x values(1,1,1,1,1);
insert into x  (with recursive tab as(select * from x) select * from tab);
drop table if exists x;
