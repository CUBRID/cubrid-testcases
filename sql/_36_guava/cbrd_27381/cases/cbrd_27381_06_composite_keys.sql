/**
 *  This test case verifies CBRD-27381: radix-sorted index builds of composite keys (MIDXKEY)
 *
 *  A composite key takes the radix sorter when its first column has a radix key. The radix columns
 *  run up to the first column without one, or until their radix keys pass 64 words. The columns after
 *  them and the ties are ordered by the compare function. t_r and t_c hold the same rows. Every index
 *  of t_r is built with index_sort_method=radix and the same index of t_c with compare, both with
 *  index_build_buffer_size 64K so a build sorts several runs. Read in index order, each radix-built
 *  index must return the rows of its compare-built twin in the same order and find as many rows.
 *
 *  Rows: g is the row generator of 6000 rows in four shapes of 1500 (scattered, ascending, descending,
 *  few distinct values), NULL in the first column every 101st row and in the middle columns every 13th
 *  and 17th row.
 *
 *  A range on the first column skips the keys whose first column is NULL. To read those too, two keys
 *  are also indexed behind z, which is 0 in every row. A NULL column orders first, and last in a
 *  descending column.
 *
 *  Coverage:
 *    Case 1:  these keys read back in the order of the compare-built twin
 *             - (INT, VARCHAR) with few distinct values in the first column
 *             - (INT, VARCHAR utf8_en_ci DESC) - a query does not read an index led by a case-insensitive column
 *             - (DATE, DOUBLE, CHAR(4)) with NULLs in the middle columns
 *             - (INT, VARCHAR(1000)) - the radix columns stop at a column without a radix key
 *             - (VARCHAR(1000), INT) - no radix key in the first column, the compare sort
 *             - (CHAR(100) x 5 iso88591_bin, INT) - the radix columns stop past 64 words
 *             - (BIGINT DESC, TIMESTAMP, ENUM)
 *             - (z, DATE, DOUBLE, CHAR(4)) and (z, BIGINT DESC, TIMESTAMP, ENUM) - every key, NULL columns included
 *    Case 2:  each radix-built index finds the rows with a first column, and every row behind z
 *    Case 3:  behind z, the rows whose first column is NULL come first, and last when that column is descending
 *    Case 4:  keys led by a column whose radix key is built by its own branch read back in the order of the
 *             compare-built twin
 *             - (NUMERIC(25,3) DESC, INT) - a fixed NUMERIC, negative values included
 *             - (NUMERIC, INT) - NUMERIC without a precision, each value with a scale of its own
 *             - (BIT VARYING(100), INT) - bit strings of 4, 8 and 12 bits that differ only in length
 *             - (DATETIME DESC, INT)
 *             - (DOUBLE, INT) - negative values, and -0.0 and 0.0, which are the same key
 *             - (MONETARY, INT) - negative values
 *    Case 5:  each of the Case 4 radix-built indexes finds the rows with a first column
 */

drop table if exists g;
drop table if exists t_r;
drop table if exists t_c;
drop table if exists t_r2;
drop table if exists t_c2;

create table g (n int, v int);
insert into g
  select n,
         case when mod (n, 101) = 0 then null
              when n <= 1500 then mod (n * 7919, 6007) - 3003
              when n <= 3000 then (n - 1501) * 4 - 3000
              when n <= 4500 then 3000 - (n - 3001) * 4
              else mod (n, 7) * 1000 - 3000 end
  from (select rownum as n from db_class a, db_class b, db_class c limit 6000) x;

create table t_r (id int,
                  a1 int, a2 varchar(20) collate utf8_bin,
                  b1 varchar(10) collate utf8_en_ci, b2 int,
                  c1 date, c2 double, c3 char(4) collate utf8_bin,
                  d1 int, d2 varchar(1000) collate utf8_bin,
                  f1 varchar(1000) collate utf8_bin, f2 int,
                  w1 char(100) collate iso88591_bin, w2 char(100) collate iso88591_bin, w3 char(100) collate iso88591_bin,
                  w4 char(100) collate iso88591_bin, w5 char(100) collate iso88591_bin, w6 int,
                  h1 bigint, h2 timestamp, h3 enum('red', 'green', 'blue', 'cyan'), z int);

insert into t_r
  select n,
         mod (v, 50), concat ('x', mod (n * 13, 97), '_', mod (n, 7)),
         case mod (n, 3) when 0 then upper (substr (s, 1, 4)) else substr (s, 1, 4) end, mod (n * 17, 41),
         adddate (date'2000-01-01', mod (v, 30)), case when mod (n, 13) = 0 then null else mod (n, 11) / 3.0 end,
         case when mod (n, 17) = 0 then null else substr (s, 1, 4) end,
         mod (v, 40), concat (repeat ('z', mod (n, 20)), mod (n * 7, 13)),
         s, mod (n * 3, 19),
         lpad (mod (v, 9), 90, 'w'), lpad (mod (n, 5), 90, 'w'), lpad (mod (n, 3), 90, 'w'), lpad (mod (n, 2), 90, 'w'),
         lpad (mod (n * 7, 11), 90, 'w'), mod (n * 11, 23),
         cast (mod (v, 60) as bigint) * 100000000000, timestamp'2010-06-01 12:00:00' + mod (n, 9) * 3600, mod (n, 4) + 1,
         0
  from (select n, v, concat (v, substr ('abcdefghij', 1, mod (n, 4))) as s from g) x
  order by n;

create table t_c like t_r;
insert into t_c select * from t_r order by id;

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_ra on t_r (a1, a2);
create index i_rb on t_r (b2, b1 desc);
create index i_rc on t_r (c1, c2, c3);
create index i_rd on t_r (d1, d2);
create index i_rf on t_r (f1, f2);
create index i_rw on t_r (w1, w2, w3, w4, w5, w6);
create index i_rh on t_r (h1 desc, h2, h3);
create index i_rzc on t_r (z, c1, c2, c3);
create index i_rzh on t_r (z, h1 desc, h2, h3);
set system parameters 'index_sort_method=compare';
create index i_ca on t_c (a1, a2);
create index i_cb on t_c (b2, b1 desc);
create index i_cc on t_c (c1, c2, c3);
create index i_cd on t_c (d1, d2);
create index i_cf on t_c (f1, f2);
create index i_cw on t_c (w1, w2, w3, w4, w5, w6);
create index i_ch on t_c (h1 desc, h2, h3);
create index i_czc on t_c (z, c1, c2, c3);
create index i_czh on t_c (z, h1 desc, h2, h3);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

evaluate 'Case 1: each radix-built composite index reads back in the order of its compare-built twin; result = no rows differ';
-- each query prints the position and the key of the rows that differ from the compare-built twin
select 'a' as ix, x.* from ((select rownum, a1, a2 from t_r where a1 >= -100 using index i_ra)
  difference (select rownum, a1, a2 from t_c where a1 >= -100 using index i_ca)) x order by 2;
select 'b' as ix, x.* from ((select rownum, b2, upper (b1) from t_r where b2 >= 0 using index i_rb)
  difference (select rownum, b2, upper (b1) from t_c where b2 >= 0 using index i_cb)) x order by 2;
select 'c' as ix, x.* from ((select rownum, c1, nvl (c2, -1), nvl (c3, '-') from t_r where c1 >= date'0001-01-01' using index i_rc)
  difference (select rownum, c1, nvl (c2, -1), nvl (c3, '-') from t_c where c1 >= date'0001-01-01' using index i_cc)) x order by 2;
select 'd' as ix, x.* from ((select rownum, d1, d2 from t_r where d1 >= -100 using index i_rd)
  difference (select rownum, d1, d2 from t_c where d1 >= -100 using index i_cd)) x order by 2;
select 'f' as ix, x.* from ((select rownum, f1, f2 from t_r where f1 >= '' using index i_rf)
  difference (select rownum, f1, f2 from t_c where f1 >= '' using index i_cf)) x order by 2;
select 'w' as ix, x.* from ((select rownum, w1, w2, w3, w4, w5, w6 from t_r where w1 >= '' using index i_rw)
  difference (select rownum, w1, w2, w3, w4, w5, w6 from t_c where w1 >= '' using index i_cw)) x order by 2;
select 'h' as ix, x.* from ((select rownum, h1, h2, h3 from t_r where h1 >= -9000000000000000000 using index i_rh)
  difference (select rownum, h1, h2, h3 from t_c where h1 >= -9000000000000000000 using index i_ch)) x order by 2;
select 'zc' as ix, x.* from ((select rownum, nvl (c1, date'0001-01-01'), nvl (c2, -1), nvl (c3, '-') from t_r where z >= 0 using index i_rzc)
  difference (select rownum, nvl (c1, date'0001-01-01'), nvl (c2, -1), nvl (c3, '-') from t_c where z >= 0 using index i_czc)) x order by 2;
select 'zh' as ix, x.* from ((select rownum, nvl (h1, -1), h2, h3 from t_r where z >= 0 using index i_rzh)
  difference (select rownum, nvl (h1, -1), h2, h3 from t_c where z >= 0 using index i_czh)) x order by 2;

evaluate 'Case 2: each radix-built index finds the rows with a first column, and every row behind z';
-- with no rows differing in Case 1, the same count means the radix-built index holds exactly the rows of its twin
select count(*) from t_r where a1 >= -100 using index i_ra;
select count(*) from t_r where b2 >= 0 using index i_rb;
select count(*) from t_r where c1 >= date'0001-01-01' using index i_rc;
select count(*) from t_r where d1 >= -100 using index i_rd;
select count(*) from t_r where f1 >= '' using index i_rf;
select count(*) from t_r where w1 >= '' using index i_rw;
select count(*) from t_r where h1 >= -9000000000000000000 using index i_rh;
select count(*) from t_r where z >= 0 using index i_rzc;
select count(*) from t_r where z >= 0 using index i_rzh;

evaluate 'Case 3: behind z, the rows whose first column is NULL come first, and last when that column is descending';
-- each query counts the rows with a NULL first column among the first or the last 59 positions, 59 being their number
select count(*) from (select rownum as r, c1 from t_r where z >= 0 using index i_rzc) x where c1 is null and r <= 59;
select count(*) from (select rownum as r, h1 from t_r where z >= 0 using index i_rzh) x where h1 is null and r > 5941;

-- t_r2 and t_c2 hold the same rows, the first column NULL where v is NULL
create table t_r2 (id int, n1 numeric(25,3), n2 numeric, v1 bit varying(100), d1 datetime, x1 double, m1 monetary, f int);
insert into t_r2
  select n,
         v * 1.125,
         case mod (n, 3) when 0 then cast (mod (v, 50) as numeric(10,0)) when 1 then cast (v / 7.0 as numeric(12,4))
                         else cast (v * 1000.5 as numeric(20,1)) end,
         case when v is null then null
              else case mod (n, 4) when 0 then X'5' when 1 then X'50' when 2 then X'500'
                                   else cast (to_char (mod (n, 97)) as bit varying(100)) end end,
         datetime'2020-01-01 00:00:00.000' + v * 1000,
         case when v is null then null
              else case mod (n, 5) when 0 then -0.0e0 when 1 then 0.0e0 else v / 3.0 end end,
         cast (v / 3.0 as monetary),
         mod (n * 11, 17)
  from g
  order by n;
create table t_c2 like t_r2;
insert into t_c2 select * from t_r2 order by id;

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_rn1 on t_r2 (n1 desc, f);
create index i_rn2 on t_r2 (n2, f);
create index i_rv1 on t_r2 (v1, f);
create index i_rd1 on t_r2 (d1 desc, f);
create index i_rx1 on t_r2 (x1, f);
create index i_rm1 on t_r2 (m1, f);
set system parameters 'index_sort_method=compare';
create index i_cn1 on t_c2 (n1 desc, f);
create index i_cn2 on t_c2 (n2, f);
create index i_cv1 on t_c2 (v1, f);
create index i_cd1 on t_c2 (d1 desc, f);
create index i_cx1 on t_c2 (x1, f);
create index i_cm1 on t_c2 (m1, f);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

evaluate 'Case 4: composite keys led by NUMERIC, VARBIT, DATETIME, DOUBLE and MONETARY read back in the order of the compare-built twin; result = no rows differ';
-- each query prints the position and the key of the rows that differ from the compare-built twin
select 'n1' as ix, x.* from ((select rownum, n1, f from t_r2 where n1 >= -99999 using index i_rn1)
  difference (select rownum, n1, f from t_c2 where n1 >= -99999 using index i_cn1)) x order by 2;
select 'n2' as ix, x.* from ((select rownum, n2, f from t_r2 where n2 >= -99999999 using index i_rn2)
  difference (select rownum, n2, f from t_c2 where n2 >= -99999999 using index i_cn2)) x order by 2;
select 'v1' as ix, x.* from ((select rownum, v1, f from t_r2 where v1 >= X'' using index i_rv1)
  difference (select rownum, v1, f from t_c2 where v1 >= X'' using index i_cv1)) x order by 2;
select 'd1' as ix, x.* from ((select rownum, d1, f from t_r2 where d1 >= datetime'1900-01-01 00:00:00.000' using index i_rd1)
  difference (select rownum, d1, f from t_c2 where d1 >= datetime'1900-01-01 00:00:00.000' using index i_cd1)) x order by 2;
select 'x1' as ix, x.* from ((select rownum, x1, f from t_r2 where x1 >= -1.0e308 using index i_rx1)
  difference (select rownum, x1, f from t_c2 where x1 >= -1.0e308 using index i_cx1)) x order by 2;
select 'm1' as ix, x.* from ((select rownum, m1, f from t_r2 where m1 >= -99999 using index i_rm1)
  difference (select rownum, m1, f from t_c2 where m1 >= -99999 using index i_cm1)) x order by 2;

evaluate 'Case 5: each of the Case 4 radix-built indexes finds the rows with a first column';
select count(*) from t_r2 where n1 >= -99999 using index i_rn1;
select count(*) from t_r2 where n2 >= -99999999 using index i_rn2;
select count(*) from t_r2 where v1 >= X'' using index i_rv1;
select count(*) from t_r2 where d1 >= datetime'1900-01-01 00:00:00.000' using index i_rd1;
select count(*) from t_r2 where x1 >= -1.0e308 using index i_rx1;
select count(*) from t_r2 where m1 >= -99999 using index i_rm1;

drop table g;
drop table t_r;
drop table t_c;
drop table t_r2;
drop table t_c2;
