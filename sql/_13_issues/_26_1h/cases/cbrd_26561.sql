/**
 * This test case verifies CBRD-26561: 
 * Incorrect BIGINT cast result for NUMERIC values with zero integer part.
 * There is a problem where incorrect results are provided when casting a numeric with a non-zero scale to bigint.
 * The problem occurs only when the integer part is 0.
 * 
 * Coverage:
 * 1 - Negative NUMERIC value
 * 2 - Direct negative decimal literal
 * 3 - Positive fractional value with zero integer part
 * 4 - Negative fractional values with different scales
 * 5 - Fractional values below rounding boundary
 * 6 - NUMERIC column values cast to INT and BIGINT
 */

drop table if exists cbrd_26561_tbl;

evaluate 'Case 1: Negative NUMERIC value';
select
    cast(cast(-0.5 as numeric(5,3)) as int) as cast_int,
    cast(cast(-0.5 as numeric(5,3)) as bigint) as cast_bigint;

evaluate 'Case 2: Direct negative decimal literal';
select
    cast(-0.5 as int) as cast_int,
    cast(-0.5 as bigint) as cast_bigint;

evaluate 'Case 3: Positive fractional value with zero integer part';
select
    cast(cast(0.5 as numeric(5,3)) as int) as cast_int,
    cast(cast(0.5 as numeric(5,3)) as bigint) as cast_bigint;

evaluate 'Case 4: Negative fractional values with different scales';
select
    cast(cast(-0.50 as numeric(5,2)) as bigint) as scale_two,
    cast(cast(-0.5000 as numeric(10,4)) as bigint) as scale_four,
    cast(cast(-0.500000 as numeric(18,6)) as bigint) as scale_six;

evaluate 'Case 5: Fractional values below rounding boundary';
select
    cast(cast(-0.4 as numeric(5,3)) as int) as neg_int,
    cast(cast(-0.4 as numeric(5,3)) as bigint) as neg_bigint,
    cast(cast(0.4 as numeric(5,3)) as int) as pos_int,
    cast(cast(0.4 as numeric(5,3)) as bigint) as pos_bigint;

evaluate 'Case 6: NUMERIC column values cast to INT and BIGINT';
create table cbrd_26561_tbl (val numeric(10,3));
insert into cbrd_26561_tbl values (-0.5), (-0.4), (0.4), (0.5), (-1.5), (1.5);

select
    val,
    cast(val as int) as cast_int,
    cast(val as bigint) as cast_bigint
from cbrd_26561_tbl
order by val;

drop table cbrd_26561_tbl;

evaluate 'Case 7: implicit conversion - store zero-integer-part NUMERIC into SHORT/INT/BIGINT columns';
drop table if exists cbrd_26561_impl;
create table cbrd_26561_impl (id int, s_val short, i_val int, b_val bigint);
insert into cbrd_26561_impl values
    (1, -0.5, -0.5, -0.5),
    (2, 0.5, 0.5, 0.5),
    (3, -0.4, -0.4, -0.4),
    (4, 0.4, 0.4, 0.4),
    (5, -0.9, -0.9, -0.9),
    (6, 0.9, 0.9, 0.9);
-- Expected (must round like explicit CAST; the point is that this is a DIFFERENT
-- code path - domain coercion - than CAST, so it must not regress to truncation):
-- id s_val i_val b_val
-- 1 -1 -1 -1
-- 2 1 1 1
-- 3 0 0 0
-- 4 0 0 0
-- 5 -1 -1 -1
-- 6 1 1 1
select id, s_val, i_val, b_val from cbrd_26561_impl order by id;

evaluate 'Case 8: implicit conversion via UPDATE ... SET bigint_col = zero-integer-part NUMERIC';
update cbrd_26561_impl set b_val = -0.5 where id = 3;
-- Expected: id=3 -> b_val = -1 (rounded on assignment, not truncated to 0)
select id, b_val from cbrd_26561_impl where id = 3;

drop table cbrd_26561_impl;

evaluate 'Case 9: implicit conversion in predicate - fractional string compared to BIGINT column';
drop table if exists cbrd_26561_pred;
create table cbrd_26561_pred (b_val bigint);
insert into cbrd_26561_pred values (-1), (0), (1);
-- Comparing a BIGINT column against a zero-integer-part fractional literal:
-- the literal is coerced to the column domain. Confirm the coerced/compared
-- value rounds (matches -1) rather than truncating (matching 0).
-- Expected: match_rounded = 1 (the row b_val = -1 matches '-0.5' -> -1)
select count(*) as match_rounded from cbrd_26561_pred where b_val = '-0.5';

drop table cbrd_26561_pred;
