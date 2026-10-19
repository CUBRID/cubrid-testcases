-- CBRD-27381: radix-sorted index builds of composite keys (MIDXKEY)
--
-- A composite key takes the radix sorter when its first column has a radix key. The radix columns
-- run up to the first column without one, or until their radix keys pass 64 words; the columns after
-- them and the ties are ordered by the compare function. t_r and t_c hold the same rows. Every index
-- of t_r is built with index_sort_method=radix and the same index of t_c with compare, both with
-- index_build_buffer_size 64K so a build sorts several runs. Read in index order, each radix-built
-- index must return the rows of its compare-built twin in the same order (0 rows differ) and find as
-- many rows.
--
-- Rows: 6000 rows in four shapes of 1500 (scattered, ascending, descending, few distinct values),
-- NULL in the first column every 101st row and in the middle columns every 13th and 17th row.
--
-- Covers:
--   - (INT, VARCHAR) with few distinct values in the first column
--   - (INT, VARCHAR utf8_en_ci DESC): a query does not read an index led by a case-insensitive column
--   - (DATE, DOUBLE, CHAR(4)) with NULLs in the middle columns
--   - (INT, VARCHAR(1000)): the radix columns stop at a column without a radix key
--   - (VARCHAR(1000), INT): no radix key in the first column, the compare sort
--   - (CHAR(100) x 5 iso88591_bin, INT): the radix columns stop past 64 words
--   - (BIGINT DESC, TIMESTAMP, ENUM)

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

create table t_r (id int,
                  a1 int, a2 varchar(20) collate utf8_bin,
                  b1 varchar(10) collate utf8_en_ci, b2 int,
                  c1 date, c2 double, c3 char(4) collate utf8_bin,
                  d1 int, d2 varchar(1000) collate utf8_bin,
                  f1 varchar(1000) collate utf8_bin, f2 int,
                  w1 char(100) collate iso88591_bin, w2 char(100) collate iso88591_bin, w3 char(100) collate iso88591_bin,
                  w4 char(100) collate iso88591_bin, w5 char(100) collate iso88591_bin, w6 int,
                  h1 bigint, h2 timestamp, h3 enum('red', 'green', 'blue', 'cyan'));

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
         cast (mod (v, 60) as bigint) * 100000000000, timestamp'2010-06-01 12:00:00' + mod (n, 9) * 3600, mod (n, 4) + 1
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
set system parameters 'index_sort_method=compare';
create index i_ca on t_c (a1, a2);
create index i_cb on t_c (b2, b1 desc);
create index i_cc on t_c (c1, c2, c3);
create index i_cd on t_c (d1, d2);
create index i_cf on t_c (f1, f2);
create index i_cw on t_c (w1, w2, w3, w4, w5, w6);
create index i_ch on t_c (h1 desc, h2, h3);
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- rows read in index order that differ from the compare-built index: 0 each
select 'a', count(*) from ((select rownum, a1, a2 from t_r where a1 >= -100 using index i_ra)
  difference (select rownum, a1, a2 from t_c where a1 >= -100 using index i_ca)) x;
select 'b', count(*) from ((select rownum, b2, upper (b1) from t_r where b2 >= 0 using index i_rb)
  difference (select rownum, b2, upper (b1) from t_c where b2 >= 0 using index i_cb)) x;
select 'c', count(*) from ((select rownum, c1, nvl (c2, -1), nvl (c3, '-') from t_r where c1 >= date'0001-01-01' using index i_rc)
  difference (select rownum, c1, nvl (c2, -1), nvl (c3, '-') from t_c where c1 >= date'0001-01-01' using index i_cc)) x;
select 'd', count(*) from ((select rownum, d1, d2 from t_r where d1 >= -100 using index i_rd)
  difference (select rownum, d1, d2 from t_c where d1 >= -100 using index i_cd)) x;
select 'f', count(*) from ((select rownum, f1, f2 from t_r where f1 >= '' using index i_rf)
  difference (select rownum, f1, f2 from t_c where f1 >= '' using index i_cf)) x;
select 'w', count(*) from ((select rownum, w1, w2, w3, w4, w5, w6 from t_r where w1 >= '' using index i_rw)
  difference (select rownum, w1, w2, w3, w4, w5, w6 from t_c where w1 >= '' using index i_cw)) x;
select 'h', count(*) from ((select rownum, h1, h2, h3 from t_r where h1 >= -9000000000000000000 using index i_rh)
  difference (select rownum, h1, h2, h3 from t_c where h1 >= -9000000000000000000 using index i_ch)) x;

-- rows each radix-built index finds: all with a first column
select count(*) from t_r where a1 >= -100 using index i_ra;
select count(*) from t_r where c1 >= date'0001-01-01' using index i_rc;
select count(*) from t_r where w1 >= '' using index i_rw;
select count(*) from t_r where h1 >= -9000000000000000000 using index i_rh;

drop table g;
drop table t_r;
drop table t_c;
