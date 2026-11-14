/**
 *  This test case verifies CBRD-27843: ROUND of a SMALLINT, INTEGER or BIGINT wrapped around past the
 *  range of its type and was off by one where a power of ten is not exact in binary, and WIDTH_BUCKET of a
 *  NaN returned INT_MIN or a bucket picked by the order of its comparisons, a NaN converted to NUMERIC became 0, and
 *  a NaN compared as equal to every value in one comparison and unequal to every value in another
 *
 *  ROUND of an integer type now rounds to an integer place in integers: past the range of the type it
 *  raises "Data overflow" as a CAST does, and inside the range the value is exact. WIDTH_BUCKET raises
 *  "Invalid parameter for function" for a NaN operand or bound and "Invalid bucket number" for a NaN
 *  bucket count. A DOUBLE or FLOAT NaN converted to NUMERIC raises "Data overflow" as an infinity does. A NaN of
 *  FLOAT, DOUBLE or MONETARY equals a NaN of either sign and is above every other value in every comparison.
 *
 *  Coverage:
 *    Case 1:  ROUND past the range of SMALLINT, INTEGER and BIGINT columns and constants is an error
 *    Case 2:  ROUND that stays in the range is exact: places -9 and -18, a BIGINT past 2^53, place -19
 *    Case 3:  a place far below the digits gives 0 and one far above keeps the value
 *    Case 4:  results that the fix does not change
 *    Case 5:  WIDTH_BUCKET with a NaN operand, bound or bucket count, and with other values
 *    Case 6:  return_null_on_function_errors=yes gives NULL for the errors of Case 1 and Case 5
 *    Case 7:  a NaN cast, inserted or updated into a NUMERIC column raises Data overflow
 *    Case 8:  a NaN in a predicate, ORDER BY, GROUP BY, a join, an index build and scan, a unique index, against a
 *             NUMERIC column, and in a scan that filters 2000 rows a page at a time
 */
drop table if exists t_r, t_w, t_n, t_q, t_u, t_qn, t_qb;
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

evaluate 'Case 7: a NaN converted to NUMERIC raises Data overflow as an infinity does; result = five errors, then 1.50, then an error and 1.50';
create table t_n (n numeric (10, 2));
insert into t_n values (cast ('nan' as double));
insert into t_n values (cast ('nan' as float));
select cast (cast ('nan' as double) as numeric (10, 2));
select cast (d as numeric (10, 2)) from t_w where k = 'nan';
insert into t_n values (1.5);
update t_n set n = cast ('nan' as double);
select n from t_n;
-- an infinity raises the same error as before, and a finite value converts as before
select cast (cast ('inf' as double) as numeric (10, 2));
select cast (cast (1.5 as double) as numeric (10, 2));

evaluate 'Case 8: a NaN equals a NaN of either sign and is above every other value; keys 2 and 4 hold the NaNs';
create table t_q (k int, d double, f float, m monetary);
insert into t_q values (1, 1, 1, 1), (2, cast ('nan' as double), cast ('nan' as double), cast (cast ('nan' as double) as monetary));
insert into t_q values (3, 2, 2, 2), (4, -cast ('nan' as double), 3, 3), (5, null, null, null);
insert into t_q values (6, cast ('-inf' as double), -1, -1), (7, cast ('inf' as double), 4, 4);
-- a DOUBLE constant, an INTEGER constant and the select list answer alike
select k from t_q where d = cast ('nan' as double) order by 1;
select k from t_q where d = 1 order by 1;
select k from t_q where d <> 1 order by 1;
select k from t_q where d > 1.0e0 order by 1;
select k from t_q where d < cast ('nan' as double) order by 1;
select k from t_q where d = d order by 1;
select k from t_q where d between 2 and cast ('nan' as double) order by 1;
select k, if (d = 1, 'T', 'F'), if (d > 1, 'T', 'F'), if (d = cast ('nan' as double), 'T', 'F') from t_q order by 1;
-- the NaNs sort last ascending and first descending, and group and count as one value
select k from t_q order by d, k;
select k from t_q order by d desc, k;
select count (*) from (select d from t_q group by d) x;
select count (*) from t_q group by d having d = cast ('nan' as double);
select count (distinct d), if (max (d) = cast ('nan' as double), 'T', 'F') from t_q;
-- a hash join and a nested loop join find the two NaNs equal
select /*+ use_hash */ a.k, b.k from t_q a, t_q b where a.d = b.d and a.k < b.k order by 1, 2;
select /*+ use_nl */ a.k, b.k from t_q a, t_q b where a.d = b.d and a.k < b.k order by 1, 2;
-- an index over a column holding a NaN builds (a debug server failed an assertion of the index build sort) and scans in the same order
create index i_q_d on t_q (d);
create index i_q_dd on t_q (d desc);
create index i_q_kd on t_q (k, d);
create index i_q_f on t_q (f);
select k from t_q where d = cast ('nan' as double) using index i_q_d order by 1;
select k from t_q where d > 1 using index i_q_d order by 1;
select k from t_q where d >= 2 using index i_q_dd order by 1;
select k from t_q where k >= 1 and d = cast ('nan' as double) using index i_q_kd order by 1;
-- FLOAT and MONETARY order the same way
select k from t_q where f > 1 using index i_q_f order by 1;
select k from t_q where m > 1 order by 1;
-- a unique index holds one NaN, whatever its sign
create table t_u (d double unique);
insert into t_u values (1), (cast ('nan' as double));
insert into t_u values (-cast ('nan' as double));
select count (*) from t_u;
-- a NUMERIC column against a DOUBLE NaN, with and without its index: no NUMERIC reaches the NaN
create table t_qn (k int, n numeric (10, 2));
insert into t_qn values (1, 0), (2, 1.5), (3, 2);
create index i_qn on t_qn (n);
select k from t_qn where n = cast ('nan' as double) order by 1;
select k from t_qn where n < cast ('nan' as double) order by 1;
select k from t_qn where n >= cast ('nan' as double) using index i_qn order by 1;
-- 2000 rows, filtered a page at a time: a column against a constant and two columns; result = 1920, 400, 1800, 200
create table t_qb (k int, d double, e double);
insert into t_qb select i, case when mod (i, 10) = 0 then cast ('nan' as double) when mod (i, 10) = 5 then -cast ('nan' as double) else i end, case when mod (i, 10) in (0, 5) then cast ('nan' as double) when mod (i, 10) = 3 then -cast ('nan' as double) else i end from (with recursive s (i) as (select 1 union all select i + 1 from s where i < 2000) select i from s) x;
select count (*) from t_qb where d > 100.0e0;
select count (*) from t_qb where d = cast ('nan' as double);
select count (*) from t_qb where d = e;
select count (*) from t_qb where d < e;

drop table t_r, t_w, t_n, t_q, t_u, t_qn, t_qb;
