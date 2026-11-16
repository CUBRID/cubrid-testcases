-- CBRD-27381: keys without a radix key keep the compare sort, and function and filtered indexes
--
-- With index_sort_method=radix, a key domain without a radix key falls back to the merge sort: a
-- string that can reach 255 bytes (a VARCHAR(64) under utf8 at 4 bytes a character, a VARCHAR(255)
-- under ISO-8859-1, STRING), and a collation that does not order a string a byte at a time (euckr_bin,
-- utf8_ko_cs, utf8_tr_cs). A function index and a filtered index sort what their expression or filter
-- leaves. t_r and t_c hold the same rows. Every index of t_r is built with index_sort_method=radix
-- and the same index of t_c with compare, both with index_build_buffer_size 64K so a build sorts
-- several runs. Read in index order, each index of t_r must return the rows of its twin in the same
-- order (0 rows differ) and find as many rows.
--
-- Rows: 6000 strings of signed numbers with a suffix, in four shapes of 1500 (scattered, ascending,
-- descending, few distinct values), Latin-1 and Korean letters mixed in, a NULL every 101st row. f9 is
-- upper case in every third row, so LOWER () folds keys that differ in case.
--
-- Covers: VARCHAR(300) and VARCHAR(64) under utf8_bin, VARCHAR(30) under euckr_bin, utf8_ko_cs and
-- utf8_tr_cs, STRING, VARCHAR(255) under iso88591_bin; a function index on ABS () and on LOWER ();
-- a filtered index; prefix-length indexes on a VARCHAR(300), which takes the radix sorter through its
-- prefix, on a CHAR(100) and on a VARCHAR(30)

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
                  f1 varchar(300) collate utf8_bin, f2 varchar(64) collate utf8_bin, f3 varchar(30) collate euckr_bin,
                  f4 varchar(30) collate utf8_ko_cs, f5 varchar(30) collate utf8_tr_cs, f6 string collate utf8_bin,
                  f7 varchar(255) collate iso88591_bin, f8 int, f9 varchar(30) collate utf8_bin);

insert into t_r
  select n, concat (repeat ('r', mod (n, 250)), s), s, s, s, s, concat (repeat ('t', mod (n, 300)), s), s, v,
         case mod (n, 3) when 0 then upper (s) else s end
  from (select n, v,
               case mod (n, 4) when 0 then upper (x.s) when 1 then concat (x.s, 'é') when 2 then concat (x.s, '가') else x.s end as s
        from (select n, v, concat (v, substr ('abcdefghij', 1, mod (n, 4))) as s from g) x) y
  order by n;

create table t_c like t_r;
insert into t_c select * from t_r order by id;

set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_r1 on t_r (f1);
create index i_r2 on t_r (f2);
create index i_r3 on t_r (f3);
create index i_r4 on t_r (f4);
create index i_r5 on t_r (f5);
create index i_r6 on t_r (f6);
create index i_r7 on t_r (f7);
create index i_r8 on t_r (abs (f8));
create index i_r9 on t_r (lower (f9));
create index i_r10 on t_r (f8) where f8 > 0;
set system parameters 'index_sort_method=compare';
create index i_c1 on t_c (f1);
create index i_c2 on t_c (f2);
create index i_c3 on t_c (f3);
create index i_c4 on t_c (f4);
create index i_c5 on t_c (f5);
create index i_c6 on t_c (f6);
create index i_c7 on t_c (f7);
create index i_c8 on t_c (abs (f8));
create index i_c9 on t_c (lower (f9));
create index i_c10 on t_c (f8) where f8 > 0;
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

-- rows read in index order that differ from the compare-built index: 0 each
select 'f1', count(*) from ((select rownum, f1 from t_r where f1 >= '' using index i_r1)
  difference (select rownum, f1 from t_c where f1 >= '' using index i_c1)) x;
select 'f2', count(*) from ((select rownum, f2 from t_r where f2 >= '' using index i_r2)
  difference (select rownum, f2 from t_c where f2 >= '' using index i_c2)) x;
select 'f3', count(*) from ((select rownum, f3 from t_r where f3 >= '' using index i_r3)
  difference (select rownum, f3 from t_c where f3 >= '' using index i_c3)) x;
select 'f4', count(*) from ((select rownum, f4 from t_r where f4 >= '' using index i_r4)
  difference (select rownum, f4 from t_c where f4 >= '' using index i_c4)) x;
select 'f5', count(*) from ((select rownum, f5 from t_r where f5 >= '' using index i_r5)
  difference (select rownum, f5 from t_c where f5 >= '' using index i_c5)) x;
select 'f6', count(*) from ((select rownum, f6 from t_r where f6 >= '' using index i_r6)
  difference (select rownum, f6 from t_c where f6 >= '' using index i_c6)) x;
select 'f7', count(*) from ((select rownum, f7 from t_r where f7 >= '' using index i_r7)
  difference (select rownum, f7 from t_c where f7 >= '' using index i_c7)) x;
-- the ABS () and LOWER () indexes are read as their keys: a key holds f8 and -f8, or f9 in both cases,
-- whose rows lie in OID order, which may differ between the two tables
select 'abs (f8)', count(*) from ((select rownum, abs (f8) from t_r where abs (f8) >= 0 using index i_r8)
  difference (select rownum, abs (f8) from t_c where abs (f8) >= 0 using index i_c8)) x;
select 'lower (f9)', count(*) from ((select rownum, lower (f9) from t_r where lower (f9) >= '' using index i_r9)
  difference (select rownum, lower (f9) from t_c where lower (f9) >= '' using index i_c9)) x;
select 'f8 > 0', count(*) from ((select rownum, f8 from t_r where f8 > 0 using index i_r10)
  difference (select rownum, f8 from t_c where f8 > 0 using index i_c10)) x;

-- rows each index of t_r finds. With 0 rows differing above, the same count means the index holds exactly
-- the rows of its twin
select count(*) from t_r where f1 >= '' using index i_r1;
select count(*) from t_r where f2 >= '' using index i_r2;
select count(*) from t_r where f3 >= '' using index i_r3;
select count(*) from t_r where f4 >= '' using index i_r4;
select count(*) from t_r where f5 >= '' using index i_r5;
select count(*) from t_r where f6 >= '' using index i_r6;
select count(*) from t_r where f7 >= '' using index i_r7;
select count(*) from t_r where abs (f8) >= 0 using index i_r8;
select count(*) from t_r where lower (f9) >= '' using index i_r9;
select count(*) from t_r where f8 > 0 using index i_r10;

-- prefix-length indexes: the key is the first characters of the column, so a VARCHAR(300) like f1, which
-- has no radix key, gets one from its prefix, and a CHAR key, padded to its precision, is cut short. The
-- keys are read as the prefix: rows that share a prefix lie in OID order, which may differ between the two
-- tables
create table t_pr (id int, l varchar(300) collate utf8_bin, w char(100) collate iso88591_bin, s varchar(30) collate utf8_bin);
create table t_pc like t_pr;
insert into t_pr
  select n, concat (v, repeat ('x', mod (n, 200))), concat (mod (n * 104729, 20011), 'w'), concat (v, substr ('abcd', 1, mod (n, 4)))
  from g order by n;
insert into t_pc select * from t_pr order by id;
set system parameters 'index_build_buffer_size=64K';
set system parameters 'index_sort_method=radix';
create index i_rpl on t_pr (l(6));
create index i_rpw on t_pr (w(5));
create index i_rps on t_pr (s(3));
set system parameters 'index_sort_method=compare';
create index i_cpl on t_pc (l(6));
create index i_cpw on t_pc (w(5));
create index i_cps on t_pc (s(3));
set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';
select 'l(6)', count(*) from ((select rownum, substr (l, 1, 6) from t_pr where l >= '' using index i_rpl)
  difference (select rownum, substr (l, 1, 6) from t_pc where l >= '' using index i_cpl)) x;
select 'w(5)', count(*) from ((select rownum, substr (w, 1, 5) from t_pr where w >= '' using index i_rpw)
  difference (select rownum, substr (w, 1, 5) from t_pc where w >= '' using index i_cpw)) x;
select 's(3)', count(*) from ((select rownum, substr (s, 1, 3) from t_pr where s >= '' using index i_rps)
  difference (select rownum, substr (s, 1, 3) from t_pc where s >= '' using index i_cps)) x;
select count(*) from t_pr where l >= '' using index i_rpl;
select count(*) from t_pr where w >= '' using index i_rpw;
select count(*) from t_pr where s >= '' using index i_rps;
drop table t_pr;
drop table t_pc;

drop table g;
drop table t_r;
drop table t_c;
