/**
 *  This test case verifies CBRD-27843: ROUND of a SMALLINT, INTEGER or BIGINT wrapped around past the
 *  range of its type and was off by one where a power of ten is not exact in binary, and WIDTH_BUCKET of a
 *  NaN returned INT_MIN or a bucket picked by the order of its comparisons
 *
 *  ROUND of an integer type now rounds to an integer place in integers: past the range of the type it
 *  raises "Data overflow" as a CAST does, and inside the range the value is exact. WIDTH_BUCKET raises
 *  "Invalid parameter for function" for a NaN operand or bound and "Invalid bucket number" for a NaN
 *  bucket count.
 *
 *  Coverage:
 *    Case 1:  ROUND past the range of SMALLINT, INTEGER and BIGINT columns and constants is an error
 *    Case 2:  ROUND that stays in the range is exact: places -9 and -18, a BIGINT past 2^53, place -19
 *    Case 3:  a place far below the digits gives 0 and one far above keeps the value
 *    Case 4:  results that the fix does not change
 *    Case 5:  WIDTH_BUCKET with a NaN operand, bound or bucket count, and with other values
 *    Case 6:  return_null_on_function_errors=yes gives NULL for the errors of Case 1 and Case 5
 */
drop table if exists t_r, t_w;
create table t_r (k varchar(8), s smallint, i int, b bigint);
insert into t_r values ('max', 32767, 2147483647, 9223372036854775807);
insert into t_r values ('min', -32768, -2147483648, -9223372036854775808);
insert into t_r values ('mid', 1234, 1234, 1234);
insert into t_r values ('p53', 15, 25, 9007199254740993);
insert into t_r values ('half', 15, -25, 4999999999999999999);
create table t_w (k varchar(8), d double);
insert into t_w values ('nan', cast ('nan' as double));
insert into t_w values ('five', 5);

evaluate 'Case 1: ROUND past the range of the type; each statement raises Data overflow';
select round (s, -1) from t_r where k = 'max';
select round (s, -1) from t_r where k = 'min';
select round (s, -2) from t_r where k = 'max';
select round (i, -1) from t_r where k = 'max';
select round (i, -1) from t_r where k = 'min';
select round (i, cast (-1 as double)) from t_r where k = 'max';
select round (b, -1) from t_r where k = 'max';
select round (b, -1) from t_r where k = 'min';
select round (b, -19) from t_r where k = 'max';
select round (cast (32767 as smallint), -1);
select round (9223372036854775807, -1);

evaluate 'Case 2: ROUND inside the range is exact; result = 2000000000, -2000000000, 9000000000000000000, -9000000000000000000, the values unchanged, 4999999999999999999, 5000000000000000000, 0';
select k, round (i, -9) from t_r where k in ('max', 'min') order by k;
select k, round (b, -18) from t_r where k in ('max', 'min') order by k;
select round (b), round (b, 2) from t_r where k = 'max';
select round (b), round (b, 0), round (b, 2), round (b, -1) from t_r where k = 'p53';
select round (b), round (b, -18), round (b, -19) from t_r where k = 'half';
select round (2147483647, -9);

evaluate 'Case 3: a place far below the digits gives 0 and one far above keeps the value; result = 0, 0, 0, then 1234 three times, then 1234, 0';
select round (s, -400), round (i, -400), round (b, -400) from t_r where k = 'max';
select round (s, 400), round (i, 400), round (b, 400) from t_r where k = 'mid';
select round (i, 9223372036854775807), round (i, -9223372036854775807) from t_r where k = 'mid';

evaluate 'Case 4: results that the fix does not change';
-- half away from zero, and a place that keeps the value
select k, round (s, -1), round (i, -1), round (b, -1) from t_r where k in ('mid', 'p53', 'half') order by k;
select round (s, 2), round (i, 2) from t_r where k = 'max';
-- a NUMERIC place is coerced to INTEGER (-2), a DOUBLE place keeps the double rounding
select round (i, -1.5), round (i, cast (-1.5 as double)) from t_r where k = 'mid';
-- a literal of 2147483647 is a BIGINT
select round (2147483647, -1), typeof (round (2147483647, -1));
select round (cast (1234.5 as double), -1), round (1234.5, 0);
-- a NaN place raises Data overflow on data type double, as before
select round (i, cast ('nan' as double)) from t_r where k = 'mid';

evaluate 'Case 5: WIDTH_BUCKET; a NaN operand or bound raises Invalid parameter for function, a NaN bucket count Invalid bucket number, then 3, 6, 0, 3';
select width_bucket (d, 0, 10, 5) from t_w where k = 'nan';
select width_bucket (5, d, 10, 5) from t_w where k = 'nan';
select width_bucket (5, 0, d, 5) from t_w where k = 'nan';
select width_bucket (5, 0, 10, d) from t_w where k = 'nan';
-- a BIGINT or NUMERIC operand takes the NUMERIC path, which coerced a NaN bound to 0
select width_bucket (cast (5 as bigint), d, 10, 5) from t_w where k = 'nan';
select width_bucket (cast (5.5 as numeric (4, 1)), 0, d, 5) from t_w where k = 'nan';
select width_bucket (cast ('nan' as double), 0, 10, 5);
select width_bucket (d, 0, 10, 5), width_bucket (cast ('inf' as double), 0, 10, 5), width_bucket (cast ('-inf' as double), 0, 10, 5), width_bucket (cast (5 as bigint), 0, 10, 5) from t_w where k = 'five';

evaluate 'Case 6: with return_null_on_function_errors=yes the errors of Case 1 and Case 5 give NULL';
set system parameters 'return_null_on_function_errors=yes';
select round (s, -1) from t_r where k = 'max';
select round (b, -19) from t_r where k = 'max';
select width_bucket (d, 0, 10, 5) from t_w where k = 'nan';
select width_bucket (5, 0, 10, d) from t_w where k = 'nan';
select width_bucket (cast (5 as bigint), d, 10, 5) from t_w where k = 'nan';
set system parameters 'return_null_on_function_errors=no';

drop table t_r, t_w;
