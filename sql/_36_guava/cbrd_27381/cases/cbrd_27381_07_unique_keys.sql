-- CBRD-27381: a unique index or primary key built from radix-sorted runs finds the same duplicates
--
-- The loader finds a duplicate key as two equal keys next to each other in the sorted stream, so the
-- radix sorter must put keys the compare function calls equal side by side: case variants under en_ci,
-- a CHAR and the same CHAR with trailing spaces, negative and positive zero, one instant in two time
-- zones. Each unique index is built twice on the same rows, with index_sort_method=radix and with
-- compare (index_build_buffer_size 64K, several runs), and both builds must end the same way: the
-- same error where a key repeats, the index where it does not.
--
-- Covers:
--   - INT: the smallest, a middle and the largest key repeated, and no repeat
--   - VARCHAR utf8_en_ci: 'abc' and 'ABC'; VARCHAR utf8_bin: 'abc' and 'ABC' are distinct
--   - CHAR: 'a' and 'a  ' are equal; VARCHAR: 'a' and 'a  ' are distinct
--   - DOUBLE: -0.0 and 0.0
--   - TIMESTAMPTZ: one instant in Asia/Seoul and in UTC
--   - composite (INT, VARCHAR): distinct pairs, a pair with a NULL column repeated, a pair repeated
--   - ALTER TABLE ... ADD PRIMARY KEY over a repeated key, and over distinct keys
--   - keys the compare function calls equal though their bytes differ, each repeated once:
--     - FLOAT -0.0 and 0.0
--     - MONETARY 12.50 in dollars and in won (the amount alone is compared)
--     - NUMERIC without a precision 1.5 and 1.50
--     - DATETIMETZ one instant in Asia/Seoul and in UTC
--     - VARCHAR iso88591_en_ci 'abc' and 'ABC'
--     - CHAR(5) utf8_en_ci 'abc' and 'ABC  '
--     - composite (INT, VARCHAR utf8_en_ci) (42, 'xyz') and (42, 'XYZ')
--   - VARCHAR utf8_en_ci 'abc' and 'ABC ': a VARCHAR keeps its trailing space, so they are distinct

drop table if exists g;
drop table if exists t_int;
drop table if exists t_str;
drop table if exists t_dbl;
drop table if exists t_tz;
drop table if exists t_mk;
drop table if exists t_pk;
drop table if exists t_flt;
drop table if exists t_mon;
drop table if exists t_num;
drop table if exists t_dtz;
drop table if exists t_ci;
drop table if exists t_mkci;

create table g (n int);
insert into g select rownum from db_class a, db_class b, db_class c limit 6000;

set system parameters 'index_build_buffer_size=64K';

-- INT: 6000 distinct keys scattered, then one repeat at a time
create table t_int (id int, k int);
insert into t_int select n, mod (n * 7919, 6007) from g order by n;
set system parameters 'index_sort_method=radix';
create unique index u_r on t_int (k);
drop index u_r on t_int;
set system parameters 'index_sort_method=compare';
create unique index u_c on t_int (k);
drop index u_c on t_int;
insert into t_int select 7001, min (k) from t_int;
set system parameters 'index_sort_method=radix';
create unique index u_r on t_int (k);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_int (k);
delete from t_int where id = 7001;
insert into t_int select 7002, k from t_int where id = 3000;
set system parameters 'index_sort_method=radix';
create unique index u_r on t_int (k);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_int (k);
delete from t_int where id = 7002;
insert into t_int select 7003, max (k) from t_int;
set system parameters 'index_sort_method=radix';
create unique index u_r on t_int (k);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_int (k);
select count(*) from db_index where class_name = 't_int';

-- VARCHAR and CHAR: case variants and trailing spaces
create table t_str (id int, ci varchar(20) collate utf8_en_ci, bin varchar(20) collate utf8_bin,
                    ch char(5) collate utf8_bin, vc varchar(5) collate utf8_bin);
insert into t_str select n, concat ('k', n), concat ('k', n), lpad (n, 5, '0'), lpad (n, 5, '0') from g order by n;
insert into t_str values (7001, 'abc', 'abc', 'a', 'a'), (7002, 'ABC', 'ABC', 'a  ', 'a  ');
set system parameters 'index_sort_method=radix';
create unique index u_r_ci on t_str (ci);
create unique index u_r_bin on t_str (bin);
create unique index u_r_ch on t_str (ch);
create unique index u_r_vc on t_str (vc);
-- a second unique index on the same column takes the first one over instead of building, so the radix
-- ones that were built are listed and dropped before the compare builds
select index_name from db_index where class_name = 't_str' order by 1;
drop index u_r_bin on t_str;
drop index u_r_vc on t_str;
set system parameters 'index_sort_method=compare';
create unique index u_c_ci on t_str (ci);
create unique index u_c_bin on t_str (bin);
create unique index u_c_ch on t_str (ch);
create unique index u_c_vc on t_str (vc);
select index_name from db_index where class_name = 't_str' order by 1;

-- DOUBLE: negative and positive zero
create table t_dbl (id int, k double);
insert into t_dbl select n, (n - 3000) / 7.0 from g where n <> 3000 order by n;
insert into t_dbl values (7001, -0.0e0), (7002, 0.0e0);
set system parameters 'index_sort_method=radix';
create unique index u_r on t_dbl (k);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_dbl (k);

-- TIMESTAMPTZ: one instant written in two zones
create table t_tz (id int, k timestamptz);
insert into t_tz select n, timestamptz'2010-06-01 12:00:00 UTC' + n * 61 from g order by n;
insert into t_tz values (7001, timestamptz'2020-01-01 09:00:00 Asia/Seoul'), (7002, timestamptz'2020-01-01 00:00:00 UTC');
set system parameters 'index_sort_method=radix';
create unique index u_r on t_tz (k);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_tz (k);

-- composite: distinct pairs, then a pair with a NULL column repeated, then a pair repeated
create table t_mk (id int, a int, b varchar(10));
insert into t_mk select n, mod (n, 100), concat ('b', n / 100) from g order by n;
set system parameters 'index_sort_method=radix';
create unique index u_r on t_mk (a, b);
drop index u_r on t_mk;
set system parameters 'index_sort_method=compare';
create unique index u_c on t_mk (a, b);
drop index u_c on t_mk;
insert into t_mk values (7001, null, 'b1'), (7002, null, 'b1');
set system parameters 'index_sort_method=radix';
create unique index u_r on t_mk (a, b);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_mk (a, b);
delete from t_mk where id >= 7001;
insert into t_mk values (7003, 42, 'b42');
set system parameters 'index_sort_method=radix';
create unique index u_r on t_mk (a, b);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_mk (a, b);

-- primary key added over the rows
create table t_pk (id int not null, k bigint not null);
insert into t_pk select n, cast (mod (n * 7919, 6007) as bigint) * 1000000007 from g order by n;
insert into t_pk values (7001, 1000000007);
set system parameters 'index_sort_method=radix';
alter table t_pk add constraint pk_r primary key (k);
set system parameters 'index_sort_method=compare';
alter table t_pk add constraint pk_c primary key (k);
delete from t_pk where id = 7001;
set system parameters 'index_sort_method=radix';
alter table t_pk add constraint pk_r primary key (k);
select count(*) from t_pk where k >= 0 using index pk_r;
alter table t_pk drop constraint pk_r;
set system parameters 'index_sort_method=compare';
alter table t_pk add constraint pk_c primary key (k);
select count(*) from t_pk where k >= 0 using index pk_c;

-- FLOAT: negative and positive zero
create table t_flt (id int, k float);
insert into t_flt select n, (n - 3000) / 7.0 from g where n <> 3000 order by n;
insert into t_flt values (7001, cast (-0.0e0 as float)), (7002, cast (0.0e0 as float));
set system parameters 'index_sort_method=radix';
create unique index u_r on t_flt (k);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_flt (k);

-- MONETARY: one amount in two currencies
create table t_mon (id int, k monetary);
insert into t_mon select n, cast ((n - 3000) / 7.0 as monetary) from g order by n;
insert into t_mon values (7001, $12.50), (7002, \12.50);
set system parameters 'index_sort_method=radix';
create unique index u_r on t_mon (k);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_mon (k);

-- NUMERIC without a precision: one value at two scales
create table t_num (id int, k numeric);
insert into t_num select n, n * 3 + 0.25 from g order by n;
insert into t_num values (7001, 1.5), (7002, 1.50);
set system parameters 'index_sort_method=radix';
create unique index u_r on t_num (k);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_num (k);

-- DATETIMETZ: one instant written in two zones
create table t_dtz (id int, k datetimetz);
insert into t_dtz
  select n, cast (concat (to_char (datetime'2010-06-01 12:00:00.000' + cast (n as bigint) * 61007, 'YYYY-MM-DD HH24:MI:SS.FF'), ' UTC') as datetimetz)
  from g order by n;
insert into t_dtz values (7001, datetimetz'2020-01-01 09:00:00.000 Asia/Seoul'), (7002, datetimetz'2020-01-01 00:00:00.000 UTC');
set system parameters 'index_sort_method=radix';
create unique index u_r on t_dtz (k);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_dtz (k);

-- case variants under iso88591_en_ci and a CHAR under utf8_en_ci, and a VARCHAR whose trailing space keeps it apart
create table t_ci (id int, iso varchar(20) collate iso88591_en_ci, chc char(5) collate utf8_en_ci, vcc varchar(20) collate utf8_en_ci);
insert into t_ci select n, concat ('k', n), lpad (n, 5, '0'), concat ('k', n) from g order by n;
insert into t_ci values (7001, 'abc', 'abc', 'abc'), (7002, 'ABC', 'ABC  ', 'ABC ');
set system parameters 'index_sort_method=radix';
create unique index u_r_iso on t_ci (iso);
create unique index u_r_chc on t_ci (chc);
create unique index u_r_vcc on t_ci (vcc);
select index_name from db_index where class_name = 't_ci' order by 1;
drop index u_r_vcc on t_ci;
set system parameters 'index_sort_method=compare';
create unique index u_c_iso on t_ci (iso);
create unique index u_c_chc on t_ci (chc);
create unique index u_c_vcc on t_ci (vcc);
select index_name from db_index where class_name = 't_ci' order by 1;

-- composite: case variants in the en_ci column of a pair
create table t_mkci (id int, a int, b varchar(10) collate utf8_en_ci);
insert into t_mkci select n, mod (n, 100), concat ('b', n / 100) from g order by n;
insert into t_mkci values (7001, 42, 'xyz'), (7002, 42, 'XYZ');
set system parameters 'index_sort_method=radix';
create unique index u_r on t_mkci (a, b);
set system parameters 'index_sort_method=compare';
create unique index u_c on t_mkci (a, b);

set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

drop table g;
drop table t_int;
drop table t_str;
drop table t_dbl;
drop table t_tz;
drop table t_mk;
drop table t_pk;
drop table t_flt;
drop table t_mon;
drop table t_num;
drop table t_dtz;
drop table t_ci;
drop table t_mkci;
