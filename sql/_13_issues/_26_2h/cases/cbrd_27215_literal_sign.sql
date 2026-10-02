/**
 * CBRD-27215 (PR #7658): the compiled expression list shares a literal with another occurrence of
 * the SAME value, and a NUMERIC value keeps its sign in the numeric header rather than in the
 * magnitude buffer.  Comparing only the buffer made 1.5 and -1.5 one literal, so "n * 1.5, n * -1.5"
 * collapsed into a single step and returned the first column's value twice, and
 * "cast(-x as numeric(38,0)) - cast(x as numeric(38,0))" returned 0.  Sign, precision and scale all
 * take part in the comparison; equal values still share.  Every result equals the interpreter's.
 */
drop table if exists ls;
create table ls (id int, n numeric(10,2), m numeric(20,6), d double, a int, b bigint);
insert into ls values
 (1, 2.00, 2.000000, 2.0, 2, 2),
 (2, -3.50, -3.500000, -3.5, -3, -3),
 (3, NULL, NULL, NULL, NULL, NULL),
 (4, 0.00, 0.000000, 0.0, 0, 0);

-- the same magnitude with both signs must not collapse into one step
select id, n * 1.5, n * -1.5, n + 1.5, n + -1.5 from ls order by id;
select id, m * 2.500000, m * -2.500000, m - 2.500000, m - -2.500000 from ls order by id;
select id, d * 1.5, d * -1.5 from ls order by id;
select id, a * 3, a * -3, b * 3, b * -3 from ls order by id;

-- equal values still share; differing scale stays separate
select id, n * 1.5, n * 1.5, n * 1.50, n * 2.5 from ls order by id;

-- constants only, no column: the 38-digit boundary the suite caught
select cast(-99999999999999999999999999999999999999 as numeric(38,0)) - cast(99999999999999999999999999999999999999 as numeric(38,0));
select cast(-99999999999999999999999999999999999999 as numeric(38,0)) a, cast(99999999999999999999999999999999999999 as numeric(38,0)) b;
select cast(-5.25 as numeric(10,2)) - cast(5.25 as numeric(10,2));
select cast(-1.5 as double) - cast(1.5 as double);
select cast(-5 as numeric(10,0)) - cast(5 as numeric(10,0));

-- the same pair as aggregate operands and in a data filter
select sum(n * 1.5), sum(n * -1.5), count(*) from ls;
select id, n from ls where n * 1.5 > 0 and n * -1.5 < 0 order by id;
select id, n * -1.5 from ls where n * 1.5 > 0 order by id;

drop table ls;
