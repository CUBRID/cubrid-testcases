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
