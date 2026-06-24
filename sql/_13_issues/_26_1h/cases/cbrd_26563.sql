/**
 * This test case verifies CBRD-26563:
 * A NUM OVERFLOW error occurred in round() for negative values ​​with an integer part of 0.
 *
 * Coverage:
 * 1 - ROUND negative decimal
 * 2 - ROUND positive decimal
 * 3 - ROUND values below the half boundary
 * 4 - ROUND negative decimal with zero scale
 * 5 - ROUND negative NUMERIC values
 */

evaluate 'Case 1: ROUND negative decimal';
select
    round(-0.5) as a,
    round(-0.61) as b;

evaluate 'Case 2: ROUND positive decimal';
select
    round(0.5) as a,
    round(0.61) as b;

evaluate 'Case 3: ROUND values below the half boundary';
select
    round(-0.4) as a,
    round(0.4) as b;

evaluate 'Case 4: ROUND negative decimal with zero scale';
select
    round(-0.5, 0) as a,
    round(-0.61, 0) as b;

evaluate 'Case 5: ROUND negative NUMERIC values';
select
    round(cast(-0.5 as numeric(5,3))) as a,
    round(cast(-0.61 as numeric(5,3))) as b;
