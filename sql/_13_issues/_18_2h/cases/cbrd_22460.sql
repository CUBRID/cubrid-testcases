
drop table if exists t;
create table t (a string, b string);
create index idx1 on t(ifnull(a,b)) with online;
create index idx2 on t(nvl(a,b)) with online;
create index idx3 on t(nvl2(a,b,'a is null')) with online;
show index from t;                                                            


drop table if exists t;
create table t (a string, b string);
insert into t values('a','b'),('c',null),(null,'d'),(null,null);
create index idx1 on t(ifnull(a,b)) with online;
create index idx2 on t(nvl(a,b)) with online;
create index idx3 on t(nvl2(a,b,'a is null')) with online;
update statistics on t;
show index from t;


drop table if exists t1;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'AB',
  N'haoABVSCDE',
  B'1111111111',
  B'1111111111',
  10,
  255,
  9223372036854775807,
  0,
  0,
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');

create index i_t1_a2m on t1(POSITION(e in B'111111111111')) with online;
create index idx_n on t1(to_char(n)) with online;
create index idx_o on t1(to_char(o)) with online;
create index idx_p on t1(to_char(p)) with online;
create index idx_q on t1(to_char(q)) with online;
create index idx_g on t1(to_char(g)) with online;
create index idx_h on t1(to_char(h)) with online;
create index idx_i on t1(to_char(i)) with online;
create index idx_j on t1(to_char(j)) with online;
create index idx_k on t1(to_char(k)) with online;
create index idx_l on t1(to_char(l)) with online;
create index idx_m on t1(to_char(m)) with online;
create index idx3 on t1(to_timestamp_tz(p)) with online;
create index idx4 on t1(to_datetime_tz(q)) with online;
create index idx_2n on t1(month(n)) with online;
create index idx_2p on t1(month(p)) with online;
create index idx_2q on t1(month(q)) with online;
create index idx5 on t1(month(a)) with online;
create index idx6 on t1(second(b)) with online;
create index idx7 on t1(hour(a)) with online;
update statistics on t1;
show index from t1;


drop table if exists t1;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
'1234567890',
'1234567890',
N'abc',
N'ABC',
B'1111111111',
B'1111111111',
10,
255,
9223372036854775807,
0,
1.5678,
-12.5678,
-24,
DATE '2008-10-31',
TIME '00:00:00',
TIMESTAMP '2010-10-31 01:15:45',
DATETIME  '2008-10-31 13:15:45');

insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
create index i_t1_a2q on t1(MINUTE(a));
create index i_t1_a2p on t1(MINUTE(b)) with online;
create index i_t1_a2o on t1(MINUTE(c)) with online;
create index i_t1_a2n on t1(MINUTE(d)) with online;
create index i_t1_a2m on t1(MINUTE(e)) with online;
create index idx_p on t1(MINUTE(p)) with online;
create index idx_q on t1(MINUTE(q)) with online;
create index idx_o on t1(MINUTE(o)) with online;
update statistics on t1;
show index from t1;

drop table if exists foo;
create table foo (a char(10), b varchar(10));
create index idx_foo_weekday_a on foo (weekday(a));
create index idx_foo_weekday_b on foo (weekday(b)) with online;
SHOW INDEXES from foo;
insert into foo values ('2010-01-01','2011-01-01');
insert into foo values ('2010-01-02','2011-01-02');
insert into foo values ('2010-01-03','2011-01-03');
insert into foo values ('2010-01-04','2011-01-04');
insert into foo values ('2010-01-05','2011-01-05');
update statistics on foo;
select /*+ recompile */ * from foo where weekday(a) >= 4;
select /*+ recompile */ * from foo where weekday(b) >= 4;
alter table foo drop column b;
update statistics on foo;
SHOW INDEXES from foo;
insert into foo values ('abc');
drop index idx_foo_weekday_a on foo;
truncate foo;
insert into foo values ('abc');
create index idx_foo_weekday_a on foo (weekday(a)) with online;

drop table if exists t;
create table t ( int_col int, float_col float, string_col varchar(100), time_col time, datetime_col datetime);
create index i_t_mi on t (mod (int_col, 2));
create index i_t_pf on t (power (float_col, 3.0)) with online;
create index i_t_dfcol on t (timediff (datetime_col, date'2010-01-01')) with online;
create index i_t_dtcol on t (timediff (datetime_col, datetime'2010-01-01 12:34:56')) with online;
create index i_t_tdcol on t (timediff (datetime_col, timestamp'2010-01-01 12:34:56')) with online;
create index i_t_td2col on t (timediff (time_col, time'12:00:00')) with online;
create index i_t_rpcol on t (replace (string_col, 'b', 'c')) with online;
show index from t;

set names iso88591;
drop table if exists t1;
create table t1(a int);
insert into t1 values (-100);
insert into t1 values (10);
select (LPAD('CUBRID', a, 'X')) from t1 order by 1;
select (LPAD(a, 10, 'X')) from t1 order by 1;
select (LPAD('CUBRID', 20, a)) from t1 order by 1;
--test: will fail and throw "No error message available.".
CREATE INDEX i1 on t1 (LPAD ('CUBRID', a, 'X'));
CREATE INDEX i2 on t1 (LPAD (a, 10, 'X')) with online;
update statistics on t1;
show index from t1;
drop table if exists t1,foo,t;
