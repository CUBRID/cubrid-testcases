-- Verification for CBRD-26293
-- ROWNUM incorrectly merged into subquery: wrong result can be returned.

----------------------------------------
-- Case 1: MAX variant
----------------------------------------
select max(main.num)
  from (
        select sub.num
          from (
                select 3 as num from dual
                union all
                select 0 as num from dual
                union all
                select 1 as num from dual
                union all
                select 4 as num from dual
                union all
                select 2 as num from dual
               ) sub
         order by sub.num asc
       ) main
 where rownum = 1;

----------------------------------------
-- Case 2: MIN variant (expanded scenario)
----------------------------------------
select min(main.num)
  from (
        select sub.num
          from (
                select 3 as num from dual
                union all
                select 0 as num from dual
                union all
                select 1 as num from dual
                union all
                select 4 as num from dual
                union all
                select 2 as num from dual
               ) sub
         order by sub.num asc
       ) main
 where rownum = 1;
