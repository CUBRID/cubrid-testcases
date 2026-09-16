/**
 * CBRD-27215 (PR #7658): two refinements of the compiled expression program.
 *
 * 1. A computing step whose inputs are all fixed is hoisted: "? * 2" and "1 + 2" run once per
 *    execution (per program for literals only) instead of once per row, the way the leaf publish and
 *    its coercion already did.  A host variable bound to a new value must still be seen by the hoisted
 *    step on the next execution, a step that can fail is hoisted only from the main loop (never from a
 *    right-hand side the interpreter may skip, never from a CASE branch), and every result and every
 *    error equals the interpreter's.
 *
 * 2. A chain of AND (or OR) in a scan filter is one flattened node evaluated in a loop rather than a
 *    descent through nested pairs.  Evaluation order, short-circuit points, three-valued results and
 *    the point at which an error is raised are those of the nested form, and the values the filter hands
 *    to the projection are unchanged.
 */
drop table if exists hc;
create table hc (id int, a int, b bigint, c int, n numeric(10,2), d double, dt date);
insert into hc values
 (1, 1, 100, 1, 1.50, 1.5, date'2026-01-15'),
 (2, 3, 200, 0, 12.34, 2.5, date'2025-06-30'),
 (3, NULL, NULL, 2, NULL, NULL, NULL),
 (4, 7, 400, 4, -7.25, -3.5, date'2024-12-01'),
 (5, -2, -500, 5, 99.99, 1e10, date'2026-09-11');

-- hoisted host-variable arithmetic sees the new binding on every execution
prepare h1 from 'select id, a * (? * 2), a + (? + 1), (? - 1) * n, cast(? as int) * 3 from hc order by id';
execute h1 using 2, 2, 2, 2;
execute h1 using 5, 5, 5, 5;
execute h1 using 2, 2, 2, 2;
execute h1 using NULL, NULL, NULL, NULL;
execute h1 using 2.5, 2.5, 2.5, 2.5;
execute h1 using 2, 2, 2, 2;
deallocate prepare h1;

-- literal-only arithmetic, run once per program
select id, a + (1 + 2), n * (10 / 4.0), cast('7' as int) + 1, extract(year from date'2026-01-01') + a from hc order by id;

-- extract over a host variable
prepare h2 from 'select id, extract(year from ?) + a, extract(month from ?) from hc order by id';
execute h2 using date'2026-03-05', date'2026-03-05';
execute h2 using date'1999-12-31', date'1999-12-31';
deallocate prepare h2;

-- a right-hand side the interpreter may skip is not hoisted: a NULL a skips 1 / ? even for a zero divisor
prepare h3 from 'select id, a + 1 / ? from hc where id = 3';
execute h3 using 0;
deallocate prepare h3;
-- the same division as a left operand is always computed: the error is raised as before
prepare h4 from 'select id, 1 / ? + a from hc where id = 3';
execute h4 using 0;
execute h4 using 2;
deallocate prepare h4;
-- a hoisted division that fails is raised when a row is evaluated, never when no row is
prepare h4b from 'select id, 1 / ? from hc where id = ?';
execute h4b using 0, 99;
execute h4b using 0, 1;
execute h4b using 4, 1;
deallocate prepare h4b;
select id, 10 / 4 from hc where id = 1;

-- inside a CASE branch the arithmetic stays in the row loop
prepare h5 from 'select id, case when a > 1 then ? * 2 else ? - 1 end from hc order by id';
execute h5 using 10, 10;
execute h5 using 3, 3;
deallocate prepare h5;

-- aggregate operands with hoisted parts
prepare h6 from 'select sum(a * (? * 2)), avg((? + 1) * n), max(cast(? as int) + b) from hc';
execute h6 using 2, 2, 2;
execute h6 using 3, 3, 3;
deallocate prepare h6;

-- AND chains: order, short-circuit, three-valued result
select id from hc where a > 0 and b > 0 and n * 2 > 3 and d < 100 order by id;
select id from hc where a > 0 and b > 150 and n > 0 and d > 0 and c >= 0 order by id;
select id from hc where (a > 0 and b > 0) and (n > 0 and d > 0) order by id;
select id from hc where a > 0 and (b > 0 and (n > 0 and d > 0)) order by id;
-- a NULL operand makes the chain UNKNOWN only when no operand is FALSE
select id from hc where a is null or (a > 0 and n > 0) order by id;
select id, (a > 0 and b > 0 and n > 0) from hc order by id;
-- an error in a later operand is reached only when the earlier ones did not stop the chain
select id from hc where a > 0 and 10 / c > 1 and b > 0 order by id;
select id from hc where c > 0 and 10 / c > 1 and b > 0 order by id;
select id from hc where a = 3 and 10 / c > 1;

-- OR chains
select id from hc where a = 1 or b = 200 or n > 90 or d < -3 order by id;
select id from hc where (a = 1 or b = 200) or (n > 90 or d < -3) order by id;
select id from hc where a = 999 or c = 0 or 10 / c > 100 order by id;
-- mixed nesting keeps the connectives apart
select id from hc where (a > 0 or b < 0) and (n > 0 or d > 0) and c >= 0 order by id;
select id from hc where a > 0 and (b < 0 or n > 10) and not (c = 4) order by id;

-- the filter's values still feed the projection
select id, n * 2, a + b from hc where n * 2 > 3 and a + b > 0 order by id;
select id, n * 2 from hc where n * 2 > 3 and a > 0 and b > 0 order by id;

-- host variables inside a chain
prepare h7 from 'select id from hc where a > ? and b > ? and n > ? order by id';
execute h7 using 0, 0, 0;
execute h7 using 0, 150, 0;
execute h7 using 0.5, 0, 0;
execute h7 using NULL, 0, 0;
execute h7 using 0, 0, 0;
deallocate prepare h7;

drop table hc;
