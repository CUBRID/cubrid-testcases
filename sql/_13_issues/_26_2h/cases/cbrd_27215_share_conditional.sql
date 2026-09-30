/**
 * CBRD-27215 (PR #7658 review, 2026-09-22): a scan-filter value that is computed only
 * conditionally -- the right side of NVL/IFNULL/COALESCE, the branch of CASE/IF/DECODE
 * that was not taken -- must not be shared with the same scan's projection or aggregates.
 * The filter accepts the row without running that node, so its slot still holds the
 * previous row's value; before the fix the second row printed 20 (the first row's b*2)
 * instead of 14 and SUM gave 40 instead of 34.  Every result equals the interpreter's.
 */
drop table if exists sc;
create table sc (a int, b int);
insert into sc values (NULL, 10), (100, 7);

select b * 2 from sc where nvl (a, b * 2) > 8 order by 1;
select b * 2 from sc where ifnull (a, b * 2) > 8 order by 1;
select b * 2 from sc where coalesce (a, b * 2) > 8 order by 1;
select sum (b * 2) from sc where nvl (a, b * 2) > 8;
select sum (b * 2), avg (b * 2), max (b * 2) from sc where coalesce (a, b * 2) > 8;
select b * 2, count (*) from sc where nvl (a, b * 2) > 8 group by b * 2 order by 1;
-- the unconditional root of a side is still shareable: a + 1 is computed for every accepted row
select a + 1, b * 2 from sc where nvl (a + 1, b * 2) > 8 order by 1;

drop table if exists sc2;
create table sc2 (a int, b int);
insert into sc2 values (1, 5), (0, 7);

select b * 2 from sc2 where (case when a > 0 then b * 2 else 0 end) >= 0 order by 1;
select b * 2 from sc2 where if (a > 0, b * 2, 0) >= 0 order by 1;
select b * 2 from sc2 where decode (a, 1, b * 2, 0) >= 0 order by 1;
select b * 2 from sc2 where (case a when 1 then b * 2 else 0 end) >= 0 order by 1;
select sum (b * 2) from sc2 where if (a > 0, b * 2, 0) >= 0;
-- the ELSE side is the conditional one when the WHEN holds
select b * 2 from sc2 where (case when a > 0 then 0 else b * 2 end) >= 0 order by 1;
-- three rows, mixed: only the rows that ran b * 2 may have a current slot, so nothing is shared
insert into sc2 values (1, 9);
select a, b * 2 from sc2 where (case when a > 0 then b * 2 else 0 end) >= 0 order by a, 2;

drop table sc;
drop table sc2;
