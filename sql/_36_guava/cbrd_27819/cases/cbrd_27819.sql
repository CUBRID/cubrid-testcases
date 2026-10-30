/**
 *  This test case verifies CBRD-27819: the faster NUMERIC code (DOUBLE and FLOAT to
 *  NUMERIC conversion, integer and NUMERIC comparison, add, subtract, multiply, ROUND,
 *  TRUNC, FLOOR, CEIL, hashing and reading) returns the values it returned before
 *  (Cases 1-5; DOUBLE/FLOAT to NUMERIC keeps 16/7 significant digits), and a BIGINT,
 *  INTEGER or NUMERIC key compared with a DOUBLE or FLOAT value the key type cannot
 *  hold exactly (beyond 2^53, 2^24, or 17 and more digits) runs on every access path
 *  without an error (Cases 6-12). That comparison is done in DOUBLE (FLOAT against a
 *  FLOAT), so an index scan, pruning, a join method or a copied equality can return
 *  other rows than a sequential scan: a documented limitation (ADR 0040, CBRD-27797,
 *  CBRD-27799, CBRD-27703); the expected rows are what each path returns.
 *  Labels with one prefix are one query on several paths: n USING INDEX NONE, no
 *  partitions or nested-loop join, i index, p RANGE, q LIST, r HASH partition,
 *  h hash join, m merge join, e the query with an equality term.
 *
 *  Coverage:
 *    Case 1:  DOUBLE and FLOAT to NUMERIC by CAST and by assignment
 *    Case 2:  SMALLINT, INTEGER, BIGINT and NUMERIC of another scale compared with NUMERIC
 *    Case 3:  NUMERIC add, subtract and multiply
 *    Case 4:  ROUND, TRUNC, FLOOR and CEIL of NUMERIC
 *    Case 5:  NUMERIC of every stored size, hash GROUP BY and query cache with NUMERIC binds
 *    Case 6:  BIGINT index, equality and ranges near 2^53 and 2^57, binds
 *    Case 7:  BIGINT index, non-integer and out-of-range DOUBLE bounds
 *    Case 8:  NUMERIC index, 17-digit values and non-integer DOUBLE values
 *    Case 9:  INTEGER, BIGINT and NUMERIC index against FLOAT near 2^24
 *    Case 10: RANGE, LIST and HASH partitions, UPDATE and DELETE, binds
 *    Case 11: nested-loop, hash and sort-merge join on a mixed key
 *    Case 12: an equality term copied into another term (col = const and col2 = col)
 */

drop table if exists t_cast, t_ic, t_ar, t_rd, t_sz, t_big, t_num, t_wide, t_flt, t_rng, t_lst, t_hsh, t_flat, t_mix, t_eq;


evaluate 'Case 1: DOUBLE and FLOAT to NUMERIC by CAST and by assignment';
select 'c1a' q, cast(12345678901234567e0 as numeric(38)), cast(144115188075855872e0 as numeric(38)), cast(9007199254740993e0 as numeric(20)), cast(1.2345678901234567e30 as numeric(38));
select 'c1b' q, cast(0.1e0 as numeric(20,18)), cast(1e0 / 3 as numeric(38,30)), cast(2e0 / 3 as numeric(10,9)), cast(0.30000000000000004e0 as numeric(20,18));
select 'c1c' q, cast(1.5e-10 as numeric(20,15)), cast(1e-20 as numeric(38,30)), cast(1e-300 as numeric(38,30)), cast(1.234567e-7 as numeric(30,20));
select 'c1d' q, cast(1.5e0 as numeric(5,0)), cast(2.5e0 as numeric(5,0)), cast(-2.5e0 as numeric(5,0)), cast(0.125e0 as numeric(5,2)), cast(0.135e0 as numeric(5,2)), cast(-0.0e0 as numeric(5,2));
select 'c1e' q, cast(-1234.5678e0 as numeric(10,2)), cast(99999.994e0 as numeric(7,2)), cast(1.234567890123456e37 as numeric(38)), cast(123e0 as numeric), cast(0.5e0 as numeric);
select 'c1f' q, cast(cast(0.1 as float) as numeric(20,18)), cast(cast(16777217 as float) as numeric(20)), cast(cast(1.5e-5 as float) as numeric(20,15)), cast(cast(-3.3 as float) as numeric(10,3)), cast(cast(1e20 as float) as numeric(38));
select 'c1g' q, cast(1e38 as numeric(38));
select 'c1h' q, cast(123.5e0 as numeric(3,1));
select 'c1i' q, cast(99999.995e0 as numeric(7,2));
select 'c1j' q, cast(9.999999999999999e37 as numeric(38));
create table t_cast (id int, n numeric(20,6), w numeric(38,0));
insert into t_cast values (1, 0.1e0, 12345678901234567e0), (2, 1e0 / 3, 9007199254740993e0), (3, -12345.6789012345e0, 1e37), (4, cast(0.1 as float), cast(16777217 as float));
update t_cast set n = n * 1e0 + 0.0000005e0 where id = 1;
select 'c1k' q, id, n, w from t_cast order by id;


evaluate 'Case 2: SMALLINT, INTEGER, BIGINT and NUMERIC of another scale compared with NUMERIC';
select 'c2a' q, cast(5 as smallint) = 5.00, cast(5 as int) < 5.01, cast(-5 as bigint) > -5.01, cast(5 as int) = 5.000000001, cast(-32768 as smallint) = -32768.0, cast(2147483647 as int) < 2147483647.5;
select 'c2b' q, cast(9223372036854775807 as bigint) < cast(9223372036854775808 as numeric(20)), cast(-9223372036854775808 as bigint) > cast(-9223372036854775809 as numeric(20)), cast(9223372036854775807 as bigint) = cast(9223372036854775807 as numeric(19)), cast(9007199254740993 as bigint) = cast(9007199254740992 as numeric(20)), cast(9007199254740993 as bigint) = cast(9007199254740993 as numeric(20));
select 'c2c' q, 5.5 between cast(5 as int) and cast(6 as bigint), cast(7 as bigint) in (6.99, 7.00, 7.01), case when cast(3 as smallint) = 3.0 then 'eq' else 'ne' end, nullif(cast(4 as int), 4.0), cast(null as int) = 1.0;
create table t_ic (id int, s smallint, i int, b bigint, n numeric(20,2), w numeric(38,0));
insert into t_ic values (1, 1, 1, 1, 1.00, 1), (2, -2, -2, -2, -2.50, -2), (3, 100, 99999, 9223372036854775807, 99999.99, 9223372036854775807), (4, 0, 0, -9223372036854775808, 0.01, -9223372036854775808), (5, 7, 7, 7, 7.00, 99999999999999999999999999999999999999), (6, null, null, null, null, null);
create index i_ic_n on t_ic (n);
create index i_ic_b on t_ic (b);
create index i_ic_w on t_ic (w);
update statistics on t_ic with fullscan;
select 'c2d' q, id, s = n, i < n, b > n, b = w, i <= w from t_ic order by id;
--@queryplan
select /*+ recompile */ 'c2ei' q, id from t_ic force index (i_ic_n) where n = 7 order by id;
select /*+ recompile */ 'c2en' q, id from t_ic where n = 7 using index none order by id;
--@queryplan
select /*+ recompile */ 'c2fi' q, id from t_ic force index (i_ic_n) where n > cast(-3 as smallint) and n < cast(100000 as bigint) order by id;
select /*+ recompile */ 'c2fn' q, id from t_ic where n > cast(-3 as smallint) and n < cast(100000 as bigint) using index none order by id;
--@queryplan
select /*+ recompile */ 'c2gi' q, id from t_ic force index (i_ic_b) where b >= 1.5 and b <= 9223372036854775807.0 order by id;
select /*+ recompile */ 'c2gn' q, id from t_ic where b >= 1.5 and b <= 9223372036854775807.0 using index none order by id;
--@queryplan
select /*+ recompile */ 'c2hi' q, id from t_ic force index (i_ic_w) where w = 9223372036854775807 or w < -9223372036854775807 order by id;
select /*+ recompile */ 'c2hn' q, id from t_ic where w = 9223372036854775807 or w < -9223372036854775807 using index none order by id;
--@queryplan
select /*+ recompile use_nl ordered */ 'c2in' q, x.id, y.id from t_ic x, t_ic y where x.b = y.w order by 2, 3;
--@queryplan
select /*+ recompile use_hash ordered */ 'c2ih' q, x.id, y.id from t_ic x, t_ic y where x.b = y.w order by 2, 3;
--@queryplan
select /*+ recompile use_nl ordered */ 'c2jn' q, x.id, y.id from t_ic x, t_ic y where x.i = y.n order by 2, 3;
--@queryplan
select /*+ recompile use_hash ordered */ 'c2jh' q, x.id, y.id from t_ic x, t_ic y where x.i = y.n order by 2, 3;
prepare st_ic from 'select ? q, id from t_ic where b = ? or n = ? order by id';
execute st_ic using 'c2k', 7.00, 99999;
execute st_ic using 'c2l', 9223372036854775807, -2.5;
deallocate prepare st_ic;
select 'c2m' q, cast(1.5 as numeric(5,1)) = cast(1.50 as numeric(10,2)), cast(-1.25 as numeric(3,2)) < cast(-1.2 as numeric(2,1)), cast(-7.25 as numeric(3,2)) < cast(-7.24 as numeric(30,2)), cast(12345678901234567890.5 as numeric(21,1)) = cast(12345678901234567890.50 as numeric(22,2)), cast(0 as numeric(5,0)) = cast(-0.00 as numeric(5,2));
select 'c2n' q, cast(1 as numeric(38)) = cast(1.0000000000000000000000000000000000000 as numeric(38,37)), cast(99999999999999999999999999999999999999 as numeric(38)) > cast(0.99999999999999999999999999999999999999 as numeric(38,38)), cast(-99999999999999999999999999999999999999 as numeric(38)) < cast(-0.99999999999999999999999999999999999999 as numeric(38,38)), cast(999999999999999999999999999999999999.99 as numeric(38,2)) < cast(1000000000000000000000000000000000000 as numeric(37)), cast(999999999999999999999999999999999999.99 as numeric(38,2)) > cast(999999999999999999999999999999999999 as numeric(36));
select 'c2o' q, id, n = w, n < w, n > cast(-2.505 as numeric(6,3)), w > cast(9223372036854775806.5 as numeric(20,1)) from t_ic order by id;
--@queryplan
select /*+ recompile */ 'c2pi' q, id from t_ic force index (i_ic_n) where n >= cast(-2.500 as numeric(5,3)) and n < cast(99999.9901 as numeric(10,4)) order by id;
select /*+ recompile */ 'c2pn' q, id from t_ic where n >= cast(-2.500 as numeric(5,3)) and n < cast(99999.9901 as numeric(10,4)) using index none order by id;
--@queryplan
select /*+ recompile use_nl ordered */ 'c2qn' q, x.id, y.id from t_ic x, t_ic y where x.n = y.w order by 2, 3;
--@queryplan
select /*+ recompile use_hash ordered */ 'c2qh' q, x.id, y.id from t_ic x, t_ic y where x.n = y.w order by 2, 3;


evaluate 'Case 3: NUMERIC add, subtract and multiply';
select 'c3a' q, cast(12345678901234567 as numeric(38)) + 1, cast(99999999999999999999999999999999999998 as numeric(38)) + 1, cast(0.999 as numeric(4,3)) + cast(0.001 as numeric(4,3)), cast(1.25 as numeric(5,2)) + cast(3 as bigint);
select 'c3b' q, cast(1 as numeric(38,10)) - cast(0.0000000001 as numeric(38,10)), cast(-99999.99 as numeric(7,2)) - 0.01, cast(5 as numeric(10)) - cast(5.000001 as numeric(10,6)), cast(-9223372036854775808 as numeric(20)) - 1;
select 'c3c' q, cast(1.25 as numeric(5,2)) * cast(3 as bigint), cast(12345678901234567890 as numeric(20)) * cast(12345678901234567 as numeric(17)), cast(1.0000000001 as numeric(38,10)) * cast(1.0000000001 as numeric(38,10)), cast(-0.5 as numeric(2,1)) * cast(0 as numeric(1));
select 'c3d' q, cast(99999999999999999999 as numeric(20)) * cast(9999999999999999999 as numeric(19)), cast(123456789.123456789 as numeric(38,9)) * cast(987654321.987654321 as numeric(38,9));
select 'c3e' q, cast(99999999999999999999999999999999999999 as numeric(38)) + 1;
select 'c3f' q, cast(10000000000000000000 as numeric(20)) * cast(10000000000000000000 as numeric(20));
select 'c3g' q, typeof(cast(1 as numeric(5,2)) + 1e0), typeof(cast(1 as numeric(5,2)) + cast(1 as numeric(10,4))), typeof(cast(1 as numeric(38,10)) * cast(1 as numeric(38,10))), typeof(cast(1 as numeric(15,2)) * cast(1 as numeric(15,2)));
create table t_ar (id int, a numeric(15,2), b numeric(15,2), c numeric(38,10), d numeric(28,4));
insert into t_ar values (1, 1234567890123.45, 2.50, 1234567890.0123456789, 123456789012345678901234.5678), (2, -0.01, 0.01, -0.0000000001, -1.0001), (3, 9999999999999.99, -9999999999999.99, 9999999999999999999999999999.9999999999, 0), (4, null, 1, 1, 1);
select 'c3h' q, id, a + b, a - b, a * b, c + d, c - d, c * c, d * d from t_ar order by id;
select 'c3i' q, sum(a), sum(c), avg(a), sum(a * b), sum(d - c) from t_ar;


evaluate 'Case 4: ROUND, TRUNC, FLOOR and CEIL of NUMERIC';
select 'c4a' q, round(cast(2.5 as numeric(3,1)), 0), round(cast(-2.5 as numeric(3,1)), 0), round(cast(1.005 as numeric(5,3)), 2), round(cast(-0.4 as numeric(2,1)), 0), round(cast(123.456 as numeric(6,3)), -1), round(cast(155 as numeric(3)), -1), round(cast(-150 as numeric(3)), -2);
select 'c4b' q, trunc(cast(2.59 as numeric(3,2)), 1), trunc(cast(-2.59 as numeric(3,2)), 1), trunc(cast(-0.09 as numeric(3,2)), 1), trunc(cast(1234.5 as numeric(5,1)), -2), trunc(cast(99.99 as numeric(4,2)), 0);
select 'c4c' q, floor(cast(2.5 as numeric(3,1))), floor(cast(-2.5 as numeric(3,1))), ceil(cast(2.1 as numeric(3,1))), ceil(cast(-2.9 as numeric(3,1))), ceil(cast(99.5 as numeric(3,1))), floor(cast(-99.5 as numeric(3,1))), ceil(cast(-0.5 as numeric(2,1)));
select 'c4d' q, round(cast(99999999999999999999999999999999999.995 as numeric(38,3)), 2), round(cast(12345678901234567890.123456789 as numeric(38,9)), 5), trunc(cast(-12345678901234567890.123456789 as numeric(38,9)), -10), ceil(cast(12345678901234567890.000000001 as numeric(38,9)));
select 'c4e' q, round(cast(1.23456 as numeric(6,5)), 2.7e0), round(cast(1.23456 as numeric(6,5)), cast(3 as smallint)), round(cast(1.23456 as numeric(6,5)), cast(1 as bigint)), trunc(cast(1.23456 as numeric(6,5)), 300), round(cast(123.4 as numeric(4,1)), -300);
select 'c4f' q, typeof(round(cast(2.5 as numeric(3,1)), 0)), typeof(trunc(cast(2.59 as numeric(3,2)), 1)), typeof(ceil(cast(99.5 as numeric(3,1)))), typeof(floor(cast(-2.5 as numeric(3,1)))), typeof(round(cast(155 as numeric(3)), -1));
create table t_rd (id int, n numeric(12,4));
insert into t_rd values (1, 12345678.5555), (2, -12345678.5555), (3, 0.0050), (4, -0.0050), (5, 99999999.9999), (6, null);
select 'c4g' q, id, round(n, 2), round(n, -3), trunc(n, 1), trunc(n, -1), floor(n), ceil(n), round(n) from t_rd order by id;


evaluate 'Case 5: NUMERIC of every stored size, hash GROUP BY and query cache with NUMERIC binds';
create table t_sz (id int, n1 numeric(1,0), n4 numeric(4,2), n9 numeric(9,0), n18 numeric(18,3), n19 numeric(19,0), n38 numeric(38,0), n38s numeric(38,38));
insert into t_sz values (1, 9, 99.99, 999999999, 999999999999999.999, 9999999999999999999, 99999999999999999999999999999999999999, 0.99999999999999999999999999999999999999), (2, -9, -99.99, -999999999, -999999999999999.999, -9999999999999999999, -99999999999999999999999999999999999999, -0.00000000000000000000000000000000000001), (3, 0, 0, 0, 0, 0, 0, 0), (4, 1, 0.01, 1, 0.001, 1844674407370955161, 18446744073709551616, 0.5);
select 'c5a' q, id, n1, n4, n9, n18, n19, n38, n38s from t_sz order by id;
select 'c5b' q, n4 + n4, n19 + n19, n38 - 1, n38s * 2 from t_sz where id = 4;
create table t_wide (id int, n numeric(38,0));
insert into t_wide values (1, 12345678901234567), (2, 12345678901234568), (3, 12345678901234569), (4, 144115188075855870), (5, 144115188075855872), (6, 144115188075855873);
select /*+ recompile */ 'c5c' q, n, count(*) from (select n from t_wide union all select n from t_wide union all select n * 2 from t_wide) x group by n order by n;
select /*+ recompile */ 'c5d' q, n4, count(*), sum(n38) from (select n4, n38 from t_sz union all select n4 * 1, n38 from t_sz) x group by n4 order by n4;
prepare st_qc from 'select /*+ query_cache */ ? q, id from t_wide where n >= ? order by id';
execute st_qc using 'c5e', 144115188075855870;
execute st_qc using 'c5f', 144115188075855872;
execute st_qc using 'c5g', 12345678901234568;
execute st_qc using 'c5h', 144115188075855870;
deallocate prepare st_qc;


-- BIGINT keys at 2^53-1 .. 2^53+2, around 2^57, at both ends of BIGINT, and small integers.
create table t_big (id int, b bigint);
insert into t_big values (1, 0), (2, 1), (3, 2), (4, 3), (5, 9007199254740991), (6, 9007199254740992), (7, 9007199254740993), (8, 9007199254740994), (9, 144115188075855870), (10, 144115188075855872), (11, 144115188075855873), (12, 9223372036854775807), (13, -9223372036854775808);
create index i_big_b on t_big (b);
-- NUMERIC(10,2) keys near 0.3; NUMERIC(38) keys with 17 digits, around 2^57 and the largest NUMERIC(38).
create table t_num (id int, n numeric(10,2));
insert into t_num values (1, 0.10), (2, 0.20), (3, 0.30), (4, 0.31), (5, 99999999.99);
create index i_num_n on t_num (n);
insert into t_wide values (7, 99999999999999999999999999999999999999), (8, -99999999999999999999999999999999999999);
create index i_wide_n on t_wide (n);
-- INTEGER, BIGINT and NUMERIC keys next to FLOAT 2^24 and FLOAT 0.3.
create table t_flt (id int, i int, b bigint, n numeric(12,10));
insert into t_flt values (1, 16777215, 16777215, 0.2999999821), (2, 16777216, 16777216, 0.3000000000), (3, 16777217, 16777217, 0.3000000119), (4, 16777218, 16777218, 0.3000000300);
create index i_flt_i on t_flt (i);
create index i_flt_b on t_flt (b);
create index i_flt_n on t_flt (n);
-- RANGE split at 2^53+1 and at 10, LIST one key per partition, HASH, and the plain twin of all three.
create table t_rng (k bigint, v int) partition by range (k) (partition p_lo values less than (10), partition p_mid values less than (9007199254740993), partition p_hi values less than maxvalue);
create table t_lst (k bigint, v int) partition by list (k) (partition q_a values in (9007199254740992), partition q_b values in (9007199254740993), partition q_c values in (9007199254740994), partition q_d values in (9), partition q_e values in (10), partition q_f values in (11));
create table t_hsh (k bigint, v int) partition by hash (k) partitions 4;
create table t_flat (k bigint, v int);
insert into t_rng values (9, 1), (10, 2), (11, 3), (9007199254740992, 4), (9007199254740993, 5), (9007199254740994, 6);
insert into t_lst select * from t_rng;
insert into t_hsh select * from t_rng;
insert into t_flat select * from t_rng;
-- Join input: BIGINT and NUMERIC next to a DOUBLE that is equal to them only in DOUBLE.
create table t_mix (id int, b bigint, n numeric(38,0), d double);
insert into t_mix values (1, 9007199254740993, 12345678901234567, 9007199254740992e0), (2, 9007199254740992, 12345678901234568, 12345678901234568e0), (3, 5, 5, 5.5e0);
-- b of rows 1 and 2 equals 2^53 only in DOUBLE, c = b holds only in row 2; n = m holds in row 1 with 17 digits.
create table t_eq (id int, b bigint, c bigint, n numeric(20,0), m numeric(20,0));
insert into t_eq values (1, 9007199254740992, 9007199254740993, 12345678901234568, 12345678901234568), (2, 9007199254740993, 9007199254740993, 1, 1), (3, 5, 5, 5, 5);
create index i_eq_b on t_eq (b);
create index i_eq_n on t_eq (n);
update statistics on t_big, t_num, t_wide, t_flt, t_rng, t_lst, t_hsh, t_flat, t_mix, t_eq with fullscan;


evaluate 'Case 6: BIGINT index, equality and ranges near 2^53 and 2^57, binds';
--@queryplan
select /*+ recompile */ 'c6ai' q, b from t_big force index (i_big_b) where b = 9007199254740992e0 order by b;
select /*+ recompile */ 'c6an' q, b from t_big where b = 9007199254740992e0 using index none order by b;
--@queryplan
select /*+ recompile */ 'c6bi' q, b from t_big force index (i_big_b) where b = 9007199254740994e0 order by b;
select /*+ recompile */ 'c6bn' q, b from t_big where b = 9007199254740994e0 using index none order by b;
--@queryplan
select /*+ recompile */ 'c6ci' q, b from t_big force index (i_big_b) where b > 9007199254740992e0 and b < 9007199254741000 order by b;
select /*+ recompile */ 'c6cn' q, b from t_big where b > 9007199254740992e0 and b < 9007199254741000 using index none order by b;
--@queryplan
select /*+ recompile */ 'c6di' q, b from t_big force index (i_big_b) where b >= 9007199254740992e0 and b < 9007199254741000 order by b;
select /*+ recompile */ 'c6dn' q, b from t_big where b >= 9007199254740992e0 and b < 9007199254741000 using index none order by b;
--@queryplan
select /*+ recompile */ 'c6ei' q, b from t_big force index (i_big_b) where b < 9007199254740992e0 and b > 3 order by b;
select /*+ recompile */ 'c6en' q, b from t_big where b < 9007199254740992e0 and b > 3 using index none order by b;
--@queryplan
select /*+ recompile */ 'c6fi' q, b from t_big force index (i_big_b) where b = 144115188075855872e0 order by b;
select /*+ recompile */ 'c6fn' q, b from t_big where b = 144115188075855872e0 using index none order by b;
--@queryplan
select /*+ recompile */ 'c6gi' q, b from t_big force index (i_big_b) where b in (9007199254740992e0, 144115188075855872e0) order by b;
select /*+ recompile */ 'c6gn' q, b from t_big where b in (9007199254740992e0, 144115188075855872e0) using index none order by b;
--@queryplan
select /*+ recompile */ 'c6hi' q, b from t_big force index (i_big_b) where b = 9007199254740993 or b = 9007199254740992.0e0 order by b;
select /*+ recompile */ 'c6hn' q, b from t_big where b = 9007199254740993 or b = 9007199254740992.0e0 using index none order by b;
prepare st_i from 'select /*+ recompile */ ? q, b from t_big force index (i_big_b) where b > ? and b <= ? order by b';
prepare st_n from 'select /*+ recompile */ ? q, b from t_big where b > ? and b <= ? using index none order by b';
execute st_i using 'c6ii', 9007199254740992e0, 9007199254740994;
execute st_n using 'c6in', 9007199254740992e0, 9007199254740994;
execute st_i using 'c6ji', 9007199254740991, 9007199254740992e0;
execute st_n using 'c6jn', 9007199254740991, 9007199254740992e0;
deallocate prepare st_i;
deallocate prepare st_n;
prepare st_e from 'select ? q, b from t_big where b = ? order by b';
execute st_e using 'c6k', 9007199254740992e0;
execute st_e using 'c6l', 9223372036854775807e0;
deallocate prepare st_e;


evaluate 'Case 7: BIGINT index, non-integer and out-of-range DOUBLE bounds';
--@queryplan
select /*+ recompile */ 'c7ai' q, b from t_big force index (i_big_b) where b between 0.5e0 and 2.5e0 order by b;
select /*+ recompile */ 'c7an' q, b from t_big where b between 0.5e0 and 2.5e0 using index none order by b;
--@queryplan
select /*+ recompile */ 'c7bi' q, count(*) from t_big force index (i_big_b) where b = 1.5e0;
select /*+ recompile */ 'c7bn' q, count(*) from t_big where b = 1.5e0 using index none;
--@queryplan
select /*+ recompile */ 'c7ci' q, count(*) from t_big force index (i_big_b) where b <= 1e20;
select /*+ recompile */ 'c7cn' q, count(*) from t_big where b <= 1e20 using index none;
--@queryplan
select /*+ recompile */ 'c7di' q, count(*) from t_big force index (i_big_b) where b >= 9223372036854775807e0;
select /*+ recompile */ 'c7dn' q, count(*) from t_big where b >= 9223372036854775807e0 using index none;
--@queryplan
select /*+ recompile */ 'c7ei' q, count(*) from t_big force index (i_big_b) where b < 9223372036854775807e0;
select /*+ recompile */ 'c7en' q, count(*) from t_big where b < 9223372036854775807e0 using index none;
--@queryplan
select /*+ recompile */ 'c7fi' q, count(*) from t_big force index (i_big_b) where b <= -9223372036854775808e0;
select /*+ recompile */ 'c7fn' q, count(*) from t_big where b <= -9223372036854775808e0 using index none;
--@queryplan
select /*+ recompile */ 'c7gi' q, count(*) from t_big force index (i_big_b) where b > -1e300 and b < 1e300;
select /*+ recompile */ 'c7gn' q, count(*) from t_big where b > -1e300 and b < 1e300 using index none;


evaluate 'Case 8: NUMERIC index, 17-digit values and non-integer DOUBLE values';
--@queryplan
select /*+ recompile */ 'c8ai' q, id from t_wide force index (i_wide_n) where n = 12345678901234568e0 order by id;
select /*+ recompile */ 'c8an' q, id from t_wide where n = 12345678901234568e0 using index none order by id;
--@queryplan
select /*+ recompile */ 'c8bi' q, count(*) from t_wide force index (i_wide_n) where n > 12345678901234568e0 and n < 20000000000000000;
select /*+ recompile */ 'c8bn' q, count(*) from t_wide where n > 12345678901234568e0 and n < 20000000000000000 using index none;
--@queryplan
select /*+ recompile */ 'c8ci' q, id from t_wide force index (i_wide_n) where n = 144115188075855872e0 order by id;
select /*+ recompile */ 'c8cn' q, id from t_wide where n = 144115188075855872e0 using index none order by id;
--@queryplan
select /*+ recompile */ 'c8di' q, id from t_wide force index (i_wide_n) where n >= 1e38 or n <= -1e38 order by id;
select /*+ recompile */ 'c8dn' q, id from t_wide where n >= 1e38 or n <= -1e38 using index none order by id;
--@queryplan
select /*+ recompile */ 'c8ei' q, count(*) from t_num force index (i_num_n) where n = 0.1e0 + 0.2e0;
select /*+ recompile */ 'c8en' q, count(*) from t_num where n = 0.1e0 + 0.2e0 using index none;
--@queryplan
select /*+ recompile */ 'c8fi' q, id from t_num force index (i_num_n) where n < 0.30000000000000004e0 order by id;
select /*+ recompile */ 'c8fn' q, id from t_num where n < 0.30000000000000004e0 using index none order by id;
--@queryplan
select /*+ recompile */ 'c8gi' q, id from t_num force index (i_num_n) where n = 0.3e0 order by id;
select /*+ recompile */ 'c8gn' q, id from t_num where n = 0.3e0 using index none order by id;
--@queryplan
select /*+ recompile */ 'c8hi' q, id from t_num force index (i_num_n) where n > 0.305e0 order by id;
select /*+ recompile */ 'c8hn' q, id from t_num where n > 0.305e0 using index none order by id;
--@queryplan
select /*+ recompile */ 'c8ii' q, count(*) from t_num force index (i_num_n) where n <= 1e20;
select /*+ recompile */ 'c8in' q, count(*) from t_num where n <= 1e20 using index none;


evaluate 'Case 9: INTEGER, BIGINT and NUMERIC index against FLOAT near 2^24';
--@queryplan
select /*+ recompile */ 'c9ai' q, id from t_flt force index (i_flt_i) where i = cast(16777216 as float) order by id;
select /*+ recompile */ 'c9an' q, id from t_flt where i = cast(16777216 as float) using index none order by id;
--@queryplan
select /*+ recompile */ 'c9bi' q, id from t_flt force index (i_flt_b) where b = cast(16777216 as float) order by id;
select /*+ recompile */ 'c9bn' q, id from t_flt where b = cast(16777216 as float) using index none order by id;
--@queryplan
select /*+ recompile */ 'c9ci' q, id from t_flt force index (i_flt_i) where i > cast(16777216 as float) order by id;
select /*+ recompile */ 'c9cn' q, id from t_flt where i > cast(16777216 as float) using index none order by id;
--@queryplan
select /*+ recompile */ 'c9di' q, id from t_flt force index (i_flt_n) where n = cast(0.3 as float) order by id;
select /*+ recompile */ 'c9dn' q, id from t_flt where n = cast(0.3 as float) using index none order by id;
--@queryplan
select /*+ recompile */ 'c9ei' q, id from t_flt force index (i_flt_n) where n > cast(0.3 as float) order by id;
select /*+ recompile */ 'c9en' q, id from t_flt where n > cast(0.3 as float) using index none order by id;


evaluate 'Case 10: RANGE, LIST and HASH partitions, UPDATE and DELETE, binds';
select 'c10ap' q, k, v from t_rng where k = 9007199254740992e0 order by v;
select 'c10aq' q, k, v from t_lst where k = 9007199254740992e0 order by v;
select 'c10ar' q, k, v from t_hsh where k = 9007199254740992e0 order by v;
select 'c10an' q, k, v from t_flat where k = 9007199254740992e0 order by v;
select 'c10bp' q, k, v from t_rng where k >= 9007199254740993e0 order by v;
select 'c10bq' q, k, v from t_lst where k >= 9007199254740993e0 order by v;
select 'c10bn' q, k, v from t_flat where k >= 9007199254740993e0 order by v;
select 'c10cp' q, k, v from t_rng where k < 9007199254740993e0 order by v;
select 'c10cq' q, k, v from t_lst where k < 9007199254740993e0 order by v;
select 'c10cn' q, k, v from t_flat where k < 9007199254740993e0 order by v;
select 'c10dp' q, k, v from t_rng where k < 9.5e0 order by v;
select 'c10dn' q, k, v from t_flat where k < 9.5e0 order by v;
select 'c10eq' q, k, v from t_lst where k in (9.5e0, 10e0, 10.5e0) order by v;
select 'c10en' q, k, v from t_flat where k in (9.5e0, 10e0, 10.5e0) order by v;
select 'c10fp' q, k, v from t_rng where k between 9.5e0 and 10.5e0 order by v;
select 'c10fn' q, k, v from t_flat where k between 9.5e0 and 10.5e0 order by v;
select 'c10gr' q, k, v from t_hsh where k = 10e0 or k = 9.5e0 order by v;
select 'c10gn' q, k, v from t_flat where k = 10e0 or k = 9.5e0 order by v;
select 'c10hr' q, k, v from t_hsh where k in (9007199254740994e0, 11e0) order by v;
select 'c10hn' q, k, v from t_flat where k in (9007199254740994e0, 11e0) order by v;
prepare st_p from 'select ? q, k, v from t_rng where k = ? order by v';
execute st_p using 'c10ip', 9007199254740992e0;
execute st_p using 'c10jp', 10e0;
deallocate prepare st_p;
prepare st_q from 'select ? q, k, v from t_lst where k = ? order by v';
execute st_q using 'c10iq', 9007199254740992e0;
execute st_q using 'c10jq', 10e0;
deallocate prepare st_q;
update t_rng set v = v + 100 where k = 9007199254740992e0;
update t_lst set v = v + 100 where k = 9007199254740992e0;
update t_hsh set v = v + 100 where k = 9007199254740992e0;
update t_flat set v = v + 100 where k = 9007199254740992e0;
select 'c10kp' q, k, v from t_rng order by k, v;
select 'c10kq' q, k, v from t_lst order by k, v;
select 'c10kr' q, k, v from t_hsh order by k, v;
select 'c10kn' q, k, v from t_flat order by k, v;
delete from t_rng where k = 9007199254740993e0;
delete from t_lst where k = 9007199254740993e0;
delete from t_hsh where k = 9007199254740993e0;
delete from t_flat where k = 9007199254740993e0;
select 'c10lp' q, k from t_rng order by k;
select 'c10lq' q, k from t_lst order by k;
select 'c10lr' q, k from t_hsh order by k;
select 'c10ln' q, k from t_flat order by k;


evaluate 'Case 11: nested-loop, hash and sort-merge join on a mixed key';
--@queryplan
select /*+ recompile use_nl ordered */ 'c11an' q, x.id, y.id from t_mix x, t_mix y where x.b = y.d order by 2, 3;
--@queryplan
select /*+ recompile use_hash ordered */ 'c11ah' q, x.id, y.id from t_mix x, t_mix y where x.b = y.d order by 2, 3;
--@queryplan
select /*+ recompile use_merge ordered */ 'c11am' q, x.id, y.id from t_mix x, t_mix y where x.b = y.d order by 2, 3;
--@queryplan
select /*+ recompile use_nl ordered */ 'c11bn' q, x.id, y.id from t_mix x, t_mix y where x.n = y.d order by 2, 3;
--@queryplan
select /*+ recompile use_hash ordered */ 'c11bh' q, x.id, y.id from t_mix x, t_mix y where x.n = y.d order by 2, 3;
--@queryplan
select /*+ recompile use_merge ordered */ 'c11bm' q, x.id, y.id from t_mix x, t_mix y where x.n = y.d order by 2, 3;
--@queryplan
select /*+ recompile use_nl ordered */ 'c11ci' q, x.id, y.b from t_mix x, t_big y where y.b = x.d order by 2, 3;
--@queryplan
select /*+ recompile use_nl ordered */ 'c11di' q, x.id, y.id from t_mix x, t_wide y where y.n = x.d order by 2, 3;


evaluate 'Case 12: an equality term copied into another term (col = const and col2 = col)';
--@queryplan
select /*+ recompile */ 'c12ai' q, id from t_eq force index (i_eq_b) where b = 9007199254740992e0 and c = b order by id;
select /*+ recompile */ 'c12ae' q, id from t_eq where b = 9007199254740992e0 and c = b using index none order by id;
select /*+ recompile */ 'c12an' q, id from t_eq where b + 0 = 9007199254740992e0 and c = b + 0 using index none order by id;
--@queryplan
select /*+ recompile */ 'c12bi' q, count(*) from t_eq force index (i_eq_n) where n = 12345678901234568e0 and m = n;
select /*+ recompile */ 'c12be' q, count(*) from t_eq where n = 12345678901234568e0 and m = n using index none;
select /*+ recompile */ 'c12bn' q, count(*) from t_eq where n + 0 = 12345678901234568e0 and m = n + 0 using index none;
select /*+ recompile */ 'c12c' q, b, c from t_eq where b = 9007199254740992e0 order by b, c;

drop table t_cast, t_ic, t_ar, t_rd, t_sz, t_big, t_num, t_wide, t_flt, t_rng, t_lst, t_hsh, t_flat, t_mix, t_eq;
