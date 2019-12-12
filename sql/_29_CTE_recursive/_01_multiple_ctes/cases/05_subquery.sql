-- This testcase use modified PostgreSQL samples. See below for the license:
-- Portions Copyright (c) 1996-2017, The PostgreSQL Global Development Group
-- Portions Copyright (c) 1994, The Regents of the University of California
-- Permission to use, copy, modify, and distribute this software and its
--  documentation for any purpose, without fee, and without a written agreement is
--  hereby granted, provided that the above copyright notice and this paragraph
--  and the following two paragraphs appear in all copies.
-- IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
--  DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES, INCLUDING
--  LOST PROFITS, ARISING OUT OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION,
--  EVEN IF THE UNIVERSITY OF CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF
--  SUCH DAMAGE.
-- THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES, INCLUDING,
--  BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--  A PARTICULAR PURPOSE. THE SOFTWARE PROVIDED HEREUNDER IS ON AN "AS IS" BASIS,
--  AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATIONS TO PROVIDE MAINTENANCE,
--  SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS.
drop if exists sales;
create table sales(region varchar,product varchar,order_amt int);
insert into sales select 'china','china'||rownum,rownum from db_root connect by level<=1000;
insert into sales select 'china','hamberg'||rownum,rownum from db_root connect by level<=1000;
insert into sales select 'english','hamberg'||rownum,rownum+1000 from db_root connect by level<=1000;
insert into sales select 'english','music'||rownum,rownum+1000 from db_root connect by level<=1000;
WITH recursive regional_sales AS (
       SELECT region
       ,      NVL(SUM(order_amt),0) AS total_sales
       FROM   sales
       GROUP  BY
              region
       )
    SELECT region
   ,      total_sales
   FROM   regional_sales
   WHERE  total_sales > (SELECT SUM(total_sales)/3 AS one_third_sales
                         FROM   regional_sales);
drop if exists sales;
