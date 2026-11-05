/**
 *  This test case verifies CBRD-27798: a hash list scan pairs equal NUMERIC keys whatever their scale and whether
 *  they are fixed or floating. A key pair with a floating NUMERIC side hashed in DOUBLE before the fix, and past
 *  15 digits the same value written in two scales rounded to two DOUBLEs, so the scan missed the pair without an
 *  error. Every check compares the hash list scan with NO_HASH_LIST_SCAN.
 *
 *  Coverage:
 *    Case 1: the shapes of the issue - literal and host variable arithmetic keys against NUMERIC(18,2), NUMERIC(38,0)
 *            against NUMERIC(38,2) + 0, BIGINT against NUMERIC(38,2) + 0
 *    Case 2: values of 1 to 32 digits (trailing zeros, negative, zero) against keys of another scale, floating keys
 *            and integer keys
 *    Case 3: a floating value spelled with a negative scale against the same value at scale 0
 *    Case 4: CONNECT BY over NUMERIC keys of two scales
 *    Case 5: the hash join and GROUP BY over the same keys
 */

drop table if exists t27798;
drop table if exists t27798b;
drop table if exists ob27798;
drop table if exists i27798;
drop table if exists v27798;
drop table if exists w27798;
drop table if exists tree27798;

evaluate 'Case 1: the shapes of the issue';
create table t27798 (a numeric(18,2), b int);
insert into t27798 values (753980177740970.00, 1), (5.00, 2);
select /*+ ORDERED */ 'c1_lit', count (*) from t27798 o, (select 753980177740969.0 + b k from t27798 limit 10) d where o.a = d.k;
select /*+ ORDERED NO_HASH_LIST_SCAN */ 'c1_lit_nohash', count (*) from t27798 o, (select 753980177740969.0 + b k from t27798 limit 10) d where o.a = d.k;
prepare s27798 from 'select /*+ ORDERED */ ''c1_bind'', count (*) from t27798 o, (select b + ? k from t27798 limit 10) d where o.a = d.k';
execute s27798 using 753980177740969.0;
prepare n27798 from 'select /*+ ORDERED NO_HASH_LIST_SCAN */ ''c1_bind_nohash'', count (*) from t27798 o, (select b + ? k from t27798 limit 10) d where o.a = d.k';
execute n27798 using 753980177740969.0;
deallocate prepare s27798;
deallocate prepare n27798;
create table t27798b (a numeric(38,0), b numeric(38,2));
insert into t27798b values (4381872152352264, 4381872152352264.00), (1, 1.00);
select /*+ ORDERED */ 'c1_n38', count (*) from t27798b o, (select b + 0 s from t27798b limit 10) d where o.a = d.s;
select /*+ ORDERED NO_HASH_LIST_SCAN */ 'c1_n38_nohash', count (*) from t27798b o, (select b + 0 s from t27798b limit 10) d where o.a = d.s;
create table ob27798 (a bigint);
create table i27798 (b numeric(38,2));
insert into ob27798 values (1000000000000002), (1);
insert into i27798 values (1000000000000002.00), (1.00);
select /*+ ORDERED */ 'c1_bigint', count (*) from ob27798, (select b + 0 s from i27798 order by 1 limit 10) d where ob27798.a = d.s;
select /*+ ORDERED NO_HASH_LIST_SCAN */ 'c1_bigint_nohash', count (*) from ob27798, (select b + 0 s from i27798 order by 1 limit 10) d where ob27798.a = d.s;

evaluate 'Case 2: values against keys of another scale, floating keys and integer keys';
create table v27798 (id int, f2 numeric(38,2), f6 numeric(38,6), i bigint);
insert into v27798 values
  (1, 753980177740970.00, 753980177740970.000000, 753980177740970),
  (2, 4381872152352264.00, 4381872152352264.000000, 4381872152352264),
  (3, 1000000000000002.00, 1000000000000002.000000, 1000000000000002),
  (4, 12345678901234567890123456789012.34, 12345678901234567890123456789012.340000, null),
  (5, -9007199254740993.50, -9007199254740993.500000, null),
  (6, 0.00, 0.000000, 0),
  (7, 1.23, 1.230000, null),
  (8, 12.30, 12.300000, null),
  (9, 123.00, 123.000000, 123),
  (10, -123.00, -123.000000, -123),
  (11, 100.00, 100.000000, 100),
  (12, 99999999999999999.99, 99999999999999999.990000, null);
select /*+ ORDERED */ 'c2_f2_f6', count (*), sum (o.id) from v27798 o, (select f6 k from v27798 limit 100) d where o.f2 = d.k;
select /*+ ORDERED NO_HASH_LIST_SCAN */ 'c2_f2_f6_nohash', count (*), sum (o.id) from v27798 o, (select f6 k from v27798 limit 100) d where o.f2 = d.k;
select /*+ ORDERED */ 'c2_f2_float', count (*), sum (o.id) from v27798 o, (select f6 + 0 k from v27798 limit 100) d where o.f2 = d.k;
select /*+ ORDERED NO_HASH_LIST_SCAN */ 'c2_f2_float_nohash', count (*), sum (o.id) from v27798 o, (select f6 + 0 k from v27798 limit 100) d where o.f2 = d.k;
select /*+ ORDERED */ 'c2_float_float', count (*), sum (o.id) from (select id, f2 * 1 f from v27798) o, (select f6 + 0 k from v27798 limit 100) d where o.f = d.k;
select /*+ ORDERED NO_HASH_LIST_SCAN */ 'c2_float_float_nohash', count (*), sum (o.id) from (select id, f2 * 1 f from v27798) o, (select f6 + 0 k from v27798 limit 100) d where o.f = d.k;
select /*+ ORDERED */ 'c2_bigint_float', count (*), sum (o.id) from v27798 o, (select f2 + 0 k from v27798 limit 100) d where o.i = d.k;
select /*+ ORDERED NO_HASH_LIST_SCAN */ 'c2_bigint_float_nohash', count (*), sum (o.id) from v27798 o, (select f2 + 0 k from v27798 limit 100) d where o.i = d.k;
select /*+ ORDERED */ 'c2_bigint_f6', count (*), sum (o.id) from v27798 o, (select f6 k from v27798 limit 100) d where o.i = d.k;
select /*+ ORDERED NO_HASH_LIST_SCAN */ 'c2_bigint_f6_nohash', count (*), sum (o.id) from v27798 o, (select f6 k from v27798 limit 100) d where o.i = d.k;

evaluate 'Case 3: a floating value spelled with a negative scale';
create table w27798 (id int, n numeric(10,0));
insert into w27798 values (1, 100), (2, 200), (3, 1);
select /*+ ORDERED */ 'c3_negscale', count (*), sum (o.id) from w27798 o,
  (select 100000000000000000000000000000000000000100 - 100000000000000000000000000000000000000000 k from w27798 limit 10) d where o.n = d.k;
select /*+ ORDERED NO_HASH_LIST_SCAN */ 'c3_negscale_nohash', count (*), sum (o.id) from w27798 o,
  (select 100000000000000000000000000000000000000100 - 100000000000000000000000000000000000000000 k from w27798 limit 10) d where o.n = d.k;

evaluate 'Case 4: CONNECT BY over NUMERIC keys of two scales';
create table tree27798 (id numeric(20,2), pid numeric(30,6), v int);
insert into tree27798 values (1000000000000001.00, null, 1), (1000000000000002.50, 1000000000000001.000000, 2),
  (1000000000000003.00, 1000000000000002.500000, 3), (4.00, 1000000000000003.000000, 4), (5.10, 4.000000, 5);
select 'c4', count (*), sum (v) from tree27798 start with pid is null connect by prior id = pid;
select /*+ NO_HASH_LIST_SCAN */ 'c4_nohash', count (*), sum (v) from tree27798 start with pid is null connect by prior id = pid;
select 'c4_float', count (*), sum (v) from (select id + 0 id, pid, v from tree27798) t start with pid is null connect by prior id = pid;

evaluate 'Case 5: the hash join and GROUP BY over the same keys';
select /*+ USE_HASH */ 'c5_hj', count (*), sum (a.id) from v27798 a, v27798 b where a.f2 = b.f6;
select /*+ USE_NL */ 'c5_nl', count (*), sum (a.id) from v27798 a, v27798 b where a.f2 = b.f6;
select 'c5_gby', k, count (*) from (select f2 k from v27798 union all select f6 + 0 from v27798 union all select f6 from v27798) x group by k order by k;

drop table t27798;
drop table t27798b;
drop table ob27798;
drop table i27798;
drop table v27798;
drop table w27798;
drop table tree27798;
