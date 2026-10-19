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

drop table if exists g;
drop table if exists t_int;
drop table if exists t_str;
drop table if exists t_dbl;
drop table if exists t_tz;
drop table if exists t_mk;
drop table if exists t_pk;

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
set system parameters 'index_sort_method=compare';
create unique index u_c on t_mk (a, b);
drop index u_r on t_mk;
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

set system parameters 'index_sort_method=DEFAULT';
set system parameters 'index_build_buffer_size=DEFAULT';

drop table g;
drop table t_int;
drop table t_str;
drop table t_dbl;
drop table t_tz;
drop table t_mk;
drop table t_pk;
