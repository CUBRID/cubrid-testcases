/**
 * CBRD-27215 (PR #7658 review, 2026-09-22): NOT BETWEEN compiles to NOT (a >= lo AND a <= hi)
 * after CNF, and the AND chain under the NOT stops at its first FALSE -- which is exactly the
 * accepting case.  So the upper bound's arithmetic (c*2) has not run for an accepted row and
 * must not be shared with the projection or the aggregates; before the fix the first accepted
 * row printed NULL and the next one the previous row's c*2 (SUM 40 instead of 54).
 */
drop table if exists nb;
create table nb (a int, b int, c int, n int);
insert into nb values (1, 5, 10, 1), (100, 1, 7, 1), (3, 9, 4, 1), (50, 2, 6, 1);

select a, c, c * 2 from nb where a not between b * 2 and c * 2 order by a;
select sum (c * 2) from nb where a not between b * 2 and c * 2;
select a, c * 2 from nb where a not between b * 2 and c * 2 and n > 0 order by a;
select a, b * 2 from nb where a not between b * 2 and c * 2 order by a;
-- the compared expression itself is on every leaf's left side and always runs
select c * 2 from nb where c * 2 not between a and b order by 1;
-- the hand-written forms lose the NOT in CNF and were right before too
select a, c * 2 from nb where not (a >= b * 2 and a <= c * 2) order by a;
select a, c * 2 from nb where a < b * 2 or a > c * 2 order by a;
-- a single NOT term over a comparison: its operands always run when the row is accepted
select a, c * 2 from nb where not (c * 2 > 100) order by a;
select c * 2, count (*) from nb where a not between b * 2 and c * 2 group by c * 2 order by 1;

drop table nb;
