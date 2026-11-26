/**
 *  This test case verifies CBRD-27381: radix-sorted index builds of the number types
 *
 *  t_r and t_c hold the same rows. Every column of t_r is indexed with index_sort_method=radix and the
 *  same column of t_c with compare, both with index_build_buffer_size 64K so a build sorts several
 *  runs. Read in index order, each radix-built index must return the rows of its compare-built twin
 *  in the same order and find as many rows.
 *
 *  Rows: g is the row generator of 6000 values in four shapes of 1500 (scattered, ascending, descending,
 *  few distinct values) with a NULL every 101st row. Then come the extremes of each type, zero and
 *  negative zero, the smallest magnitudes (subnormal FLOAT and DOUBLE) and one amount in two currencies.
 *  A NUMERIC without a precision keeps the precision and the scale of each value, so its values are set
 *  a scale at a time (a CASE would give them one) - v / 4 at scales 2 and 6, and v * 1000000000007.
 *  Zero and 12.5 come at two scales each.
 *
 *  A fixed NUMERIC takes a radix key of 1, 5, 9, 13 or 17 bytes by its precision (1-2, 3-12, 13-21,
 *  22-31, 32-38). NUMERIC(1,0), NUMERIC(5,5) and NUMERIC(10,2), NUMERIC(15,0), NUMERIC(25,3) and
 *  NUMERIC(38,6) take one of each.
 *
 *  Coverage:
 *    Case 1:  SMALLINT, INTEGER, BIGINT, FLOAT, DOUBLE, MONETARY, NUMERIC(15,0), NUMERIC(10,2), NUMERIC(38,6),
 *             NUMERIC(5,5), NUMERIC(1,0), NUMERIC(25,3), NUMERIC without a precision (precision 40, the floating
 *             radix key), and descending indexes of INTEGER, DOUBLE, NUMERIC(38,6), NUMERIC(25,3) and NUMERIC
 *             read back in the order of the compare-built twin
 *    Case 2:  each radix-built index finds the rows whose key is not NULL
 */

drop table if exists g;
drop table if exists t_r;
drop table if exists t_c;

create table g (n int, v int);
insert into g
  select n,
         case when mod (n, 101) = 0 then null
              when n <= 1500 then mod (n * 7919, 6007) - 3003
              when n <= 3000 then (n - 1501) * 4 - 3000
              when n <= 4500 then 3000 - (n - 3001) * 4
              else mod (n, 7) * 1000 - 3000 end
  from (select rownum as n from db_class a, db_class b, db_class c limit 6000) x;

create table t_r (id int, k1 smallint, k2 int, k3 bigint, k4 float, k5 double, k6 monetary, k7 numeric(15,0),
                  k8 numeric(10,2), k9 numeric(38,6), k10 numeric(5,5), k11 numeric(1,0), k12 numeric,
                  k13 numeric(25,3));

insert into t_r
  select n, v * 10, v * 700001, cast (v as bigint) * 3000000000007, v / 7.0, v / 13.0, cast (v / 3.0 as monetary),
         cast (v as bigint) * 1000000000, v / 7.0,
         cast (concat (v, '9876543210987654321098.', lpad (mod (n * 37, 1000000), 6, '0')) as numeric(38,6)),
         v / 10000.0, mod (v, 10), null,
         cast (concat (v, '123456789012345678.', lpad (mod (n * 37, 1000), 3, '0')) as numeric(25,3))
  from g order by n;

-- k12, a scale at a time (k2 / 700001 is v)
update t_r set k12 = cast (k2 / 700001 / 4.0 as numeric(12,2)) where id <= 6000 and mod (id, 3) = 0;
update t_r set k12 = cast (k2 / 700001 / 4.0 as numeric(16,6)) where id <= 6000 and mod (id, 3) = 1;
update t_r set k12 = cast (cast (k2 / 700001 as bigint) * 1000000000007 as numeric(38,0)) where id <= 6000 and mod (id, 3) = 2;

insert into t_r values (6001, -32768, -2147483648, -9223372036854775808, -1.0e38, -1.0e308, -1.0e15,
  -999999999999999, -99999999.99, -99999999999999999999999999999999.999999, -0.99999, -9,
  -123456789012345678901234567890.12345678, -9999999999999999999999.999);
insert into t_r values (6002, 32767, 2147483647, 9223372036854775807, 1.0e38, 1.0e308, 1.0e15,
  999999999999999, 99999999.99, 99999999999999999999999999999999.999999, 0.99999, 9,
  123456789012345678901234567890.12345678, 9999999999999999999999.999);
insert into t_r values (6003, 0, 0, 0, cast (-0.0e0 as float), -0.0e0, 0, 0, 0, 0, 0, 0, 0.0, 0);
insert into t_r values (6004, 0, 0, 0, 0.0e0, 0.0e0, 0, 0, 0.00, 0.000000, 0.00000, 0, 0.000, 0.000);
insert into t_r values (6005, -1, -1, -1, 1.4e-45, 1.0e-300 / 1.0e20, 0.01, -1, -0.01, -0.000001, -0.00001, -1,
  -0.000000000000000000000000000001, -0.001);
insert into t_r values (6006, 1, 1, 1, -1.4e-45, -1.0e-300 / 1.0e20, -0.01, 1, 0.01, 0.000001, 0.00001, 1,
  0.000000000000000000000000000001, 0.001);
insert into t_r values (6007, 2, 2, 2, 1.0e-38, 1.0e-300, $12.50, 2, 12.50, 12.5, 0.125, 2, 12.5, 12.5);
insert into t_r values (6008, 2, 2, 2, 1.0e-38, 1.0e-300, \12.50, 2, 12.50, 12.5, 0.125, 2, 12.50000, 12.500);

create table t_c like t_r;
insert into t_c select * from t_r order by id;

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_r1 on t_r (k1);
create index i_r2 on t_r (k2);
create index i_r3 on t_r (k3);
create index i_r4 on t_r (k4);
create index i_r5 on t_r (k5);
create index i_r6 on t_r (k6);
create index i_r7 on t_r (k7);
create index i_r8 on t_r (k8);
create index i_r9 on t_r (k9);
create index i_r10 on t_r (k10);
create index i_r11 on t_r (k11);
create index i_r12 on t_r (k12);
create index i_r13 on t_r (k13);
create index i_r2d on t_r (k2 desc);
create index i_r5d on t_r (k5 desc);
create index i_r9d on t_r (k9 desc);
create index i_r12d on t_r (k12 desc);
create index i_r13d on t_r (k13 desc);
set system parameters 'index_sort_method=compare';
create index i_c1 on t_c (k1);
create index i_c2 on t_c (k2);
create index i_c3 on t_c (k3);
create index i_c4 on t_c (k4);
create index i_c5 on t_c (k5);
create index i_c6 on t_c (k6);
create index i_c7 on t_c (k7);
create index i_c8 on t_c (k8);
create index i_c9 on t_c (k9);
create index i_c10 on t_c (k10);
create index i_c11 on t_c (k11);
create index i_c12 on t_c (k12);
create index i_c13 on t_c (k13);
create index i_c2d on t_c (k2 desc);
create index i_c5d on t_c (k5 desc);
create index i_c9d on t_c (k9 desc);
create index i_c12d on t_c (k12 desc);
create index i_c13d on t_c (k13 desc);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

evaluate 'Case 1: each radix-built index reads back in the order of its compare-built twin; result = no rows differ';
-- each query prints the position and the key of the rows that differ from the compare-built twin
select 'k1' as ix, x.* from ((select rownum, k1 from t_r where k1 >= -32768 using index i_r1)
  difference (select rownum, k1 from t_c where k1 >= -32768 using index i_c1)) x order by 2;
select 'k2' as ix, x.* from ((select rownum, k2 from t_r where k2 >= -2147483648 using index i_r2)
  difference (select rownum, k2 from t_c where k2 >= -2147483648 using index i_c2)) x order by 2;
select 'k3' as ix, x.* from ((select rownum, k3 from t_r where k3 >= -9223372036854775808 using index i_r3)
  difference (select rownum, k3 from t_c where k3 >= -9223372036854775808 using index i_c3)) x order by 2;
select 'k4' as ix, x.* from ((select rownum, k4 from t_r where k4 >= -3.4e38 using index i_r4)
  difference (select rownum, k4 from t_c where k4 >= -3.4e38 using index i_c4)) x order by 2;
select 'k5' as ix, x.* from ((select rownum, k5 from t_r where k5 >= -1.7e308 using index i_r5)
  difference (select rownum, k5 from t_c where k5 >= -1.7e308 using index i_c5)) x order by 2;
select 'k6' as ix, x.* from ((select rownum, k6 from t_r where k6 >= -1.0e16 using index i_r6)
  difference (select rownum, k6 from t_c where k6 >= -1.0e16 using index i_c6)) x order by 2;
select 'k7' as ix, x.* from ((select rownum, k7 from t_r where k7 >= -999999999999999 using index i_r7)
  difference (select rownum, k7 from t_c where k7 >= -999999999999999 using index i_c7)) x order by 2;
select 'k8' as ix, x.* from ((select rownum, k8 from t_r where k8 >= -99999999.99 using index i_r8)
  difference (select rownum, k8 from t_c where k8 >= -99999999.99 using index i_c8)) x order by 2;
select 'k9' as ix, x.* from ((select rownum, k9 from t_r where k9 >= -99999999999999999999999999999999.999999 using index i_r9)
  difference (select rownum, k9 from t_c where k9 >= -99999999999999999999999999999999.999999 using index i_c9)) x order by 2;
select 'k10' as ix, x.* from ((select rownum, k10 from t_r where k10 >= -0.99999 using index i_r10)
  difference (select rownum, k10 from t_c where k10 >= -0.99999 using index i_c10)) x order by 2;
select 'k11' as ix, x.* from ((select rownum, k11 from t_r where k11 >= -9 using index i_r11)
  difference (select rownum, k11 from t_c where k11 >= -9 using index i_c11)) x order by 2;
select 'k12' as ix, x.* from ((select rownum, k12 from t_r where k12 >= -999999999999999999999999999999999999 using index i_r12)
  difference (select rownum, k12 from t_c where k12 >= -999999999999999999999999999999999999 using index i_c12)) x order by 2;
select 'k13' as ix, x.* from ((select rownum, k13 from t_r where k13 >= -9999999999999999999999.999 using index i_r13)
  difference (select rownum, k13 from t_c where k13 >= -9999999999999999999999.999 using index i_c13)) x order by 2;
select 'k2 desc' as ix, x.* from ((select rownum, k2 from t_r where k2 >= -2147483648 using index i_r2d)
  difference (select rownum, k2 from t_c where k2 >= -2147483648 using index i_c2d)) x order by 2;
select 'k5 desc' as ix, x.* from ((select rownum, k5 from t_r where k5 >= -1.7e308 using index i_r5d)
  difference (select rownum, k5 from t_c where k5 >= -1.7e308 using index i_c5d)) x order by 2;
select 'k9 desc' as ix, x.* from ((select rownum, k9 from t_r where k9 >= -99999999999999999999999999999999.999999 using index i_r9d)
  difference (select rownum, k9 from t_c where k9 >= -99999999999999999999999999999999.999999 using index i_c9d)) x order by 2;
select 'k12 desc' as ix, x.* from ((select rownum, k12 from t_r where k12 >= -999999999999999999999999999999999999 using index i_r12d)
  difference (select rownum, k12 from t_c where k12 >= -999999999999999999999999999999999999 using index i_c12d)) x order by 2;
select 'k13 desc' as ix, x.* from ((select rownum, k13 from t_r where k13 >= -9999999999999999999999.999 using index i_r13d)
  difference (select rownum, k13 from t_c where k13 >= -9999999999999999999999.999 using index i_c13d)) x order by 2;

evaluate 'Case 2: each radix-built index finds the rows whose key is not NULL';
-- with no rows differing in Case 1, the same count means the radix-built index holds exactly the rows of its twin
select count(*) from t_r where k1 >= -32768 using index i_r1;
select count(*) from t_r where k2 >= -2147483648 using index i_r2;
select count(*) from t_r where k3 >= -9223372036854775808 using index i_r3;
select count(*) from t_r where k4 >= -3.4e38 using index i_r4;
select count(*) from t_r where k5 >= -1.7e308 using index i_r5;
select count(*) from t_r where k6 >= -1.0e16 using index i_r6;
select count(*) from t_r where k7 >= -999999999999999 using index i_r7;
select count(*) from t_r where k8 >= -99999999.99 using index i_r8;
select count(*) from t_r where k9 >= -99999999999999999999999999999999.999999 using index i_r9;
select count(*) from t_r where k10 >= -0.99999 using index i_r10;
select count(*) from t_r where k11 >= -9 using index i_r11;
select count(*) from t_r where k12 >= -999999999999999999999999999999999999 using index i_r12;
select count(*) from t_r where k13 >= -9999999999999999999999.999 using index i_r13;
select count(*) from t_r where k2 >= -2147483648 using index i_r2d;
select count(*) from t_r where k5 >= -1.7e308 using index i_r5d;
select count(*) from t_r where k9 >= -99999999999999999999999999999999.999999 using index i_r9d;
select count(*) from t_r where k12 >= -999999999999999999999999999999999999 using index i_r12d;
select count(*) from t_r where k13 >= -9999999999999999999999.999 using index i_r13d;

drop table g;
drop table t_r;
drop table t_c;
