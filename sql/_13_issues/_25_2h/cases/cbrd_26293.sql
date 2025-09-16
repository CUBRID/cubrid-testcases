-- Verification for CBRD-26293
-- ROWNUM incorrectly merged into subquery: wrong result can be returned.

----------------------------------------
-- Case 1: MAX with subquery ORDER BY
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
-- Case 2: MAX with subquery ORDER BY desc
----------------------------------------
select max(maindesc.num)
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
         order by sub.num desc
       ) maindesc
 where rownum = 1;

----------------------------------------
-- Case 3: MIN with subquery ORDER BY 
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

----------------------------------------
-- Case 4: MIN with subquery ORDER BY desc
----------------------------------------
select min(maindesc.num)
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
         order by sub.num desc
       ) maindesc
 where rownum = 1;


----------------------------------------
-- Case 5: DISTINCT with subquery ORDER BY
----------------------------------------
select /*+ recompile */ distinct main.num2
          from (select sub.num, sub.num2
                    from (select 3 as num, 3 as num2 FROM dual
                             union all
                             select 0 as num, 0 as num2 FROM dual) sub
                 order by sub.num asc) main
where rownum = 1;


