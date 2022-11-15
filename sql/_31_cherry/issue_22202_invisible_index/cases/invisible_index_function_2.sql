drop table if exists t;
create table t (a string, b string);
create index idx1 on t(ifnull(a,b)) invisible;
create index idx2 on t(nvl(a,b)) invisible;
create index idx3 on t(nvl2(a,b,'a is null')) invisible;
update statistics on all classes;
show index from t;

drop table if exists t;
create table t (a string, b string);
insert into t values('a','b'),('c',null),(null,'d'),(null,null);
create index idx1 on t(ifnull(a,b)) invisible;
create index idx2 on t(nvl(a,b)) invisible;
create index idx3 on t(nvl2(a,b,'a is null')) invisible;
update statistics on all classes;
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
create index i_t1_a2m on t1(POSITION(e in B'111111111111')) invisible;
create index idx_n on t1(to_char(n)) invisible;
create index idx_o on t1(to_char(o)) invisible;
create index idx_p on t1(to_char(p)) invisible;
create index idx_q on t1(to_char(q)) invisible;
create index idx_g on t1(to_char(g)) invisible;
create index idx_h on t1(to_char(h)) invisible;
create index idx_i on t1(to_char(i)) invisible;
create index idx_j on t1(to_char(j)) invisible;
create index idx_k on t1(to_char(k)) invisible;
create index idx_l on t1(to_char(l)) invisible;
create index idx_m on t1(to_char(m)) invisible;
create index idx3 on t1(to_timestamp_tz(p)) invisible;
create index idx4 on t1(to_datetime_tz(q)) invisible;
create index idx_2n on t1(month(n)) invisible;
create index idx_2p on t1(month(p)) invisible;
create index idx_2q on t1(month(q)) invisible;
create index idx5 on t1(month(a)) invisible;
create index idx6 on t1(second(b)) invisible;
create index idx7 on t1(hour(a)) invisible;
update statistics on all classes;
show index from t1;
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
create index i_t1_a2q on t1(MINUTE(a)) invisible;
create index i_t1_a2p on t1(MINUTE(b)) invisible;
create index i_t1_a2o on t1(MINUTE(c)) invisible;
create index i_t1_a2n on t1(MINUTE(d)) invisible;
create index i_t1_a2m on t1(MINUTE(e)) invisible;
create index idx_p on t1(MINUTE(p)) invisible;
create index idx_q on t1(MINUTE(q)) invisible;
create index idx_o on t1(MINUTE(o)) invisible;
update statistics on all classes;
show index from t1;

drop table if exists t;
create table t ( int_col int, float_col float, string_col varchar(100), time_col time, datetime_col datetime);
create index i_t_mi on t (mod (int_col, 2)) invisible;
create index i_t_pf on t (power (float_col, 3.0)) invisible;
create index i_t_dfcol on t (timediff (datetime_col, date'2010-01-01')) invisible;
create index i_t_dtcol on t (timediff (datetime_col, datetime'2010-01-01 12:34:56')) invisible;
create index i_t_tdcol on t (timediff (datetime_col, timestamp'2010-01-01 12:34:56')) invisible;
create index i_t_td2col on t (timediff (time_col, time'12:00:00')) invisible;
create index i_t_rpcol on t (replace (string_col, 'b', 'c')) invisible;
update statistics on all classes;
show index from t;

set names iso88591;
drop table if exists t1;
create table t1(a int);
insert into t1 values (-100);
insert into t1 values (10);
select (LPAD('CUBRID', a, 'X')) from t1 order by 1;
select (LPAD(a, 10, 'X')) from t1 order by 1;
select (LPAD('CUBRID', 20, a)) from t1 order by 1;
CREATE INDEX i1 on t1 (LPAD ('CUBRID', a, 'X')) invisible;
CREATE INDEX i2 on t1 (LPAD (a, 10, 'X')) invisible;
update statistics on all classes;
show index from t1;

drop table if exists t1,foo,t;


drop table if exists t1;
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin', 'jian ye',31,'M');
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName)) with online ;
--@queryplan
SELECT /*+ recompile */ * FROM t1 WHERE LOWER(FirstName)='yin' using index first_name_lower(+);
ALTER INDEX first_name_lower ON T1 INVISIBLE;
--@queryplan
SELECT /*+ recompile */ * FROM t1 WHERE LOWER(FirstName)='yin' using index first_name_lower(+);
ALTER  INDEX first_name_lower on t1(firstname) WHERE LOWER(FirstName)='yin' REBUILD;
--@queryplan
SELECT /*+ recompile */ * FROM t1 WHERE LOWER(FirstName)='yin' using index first_name_lower(+);
ALTER INDEX first_name_lower ON T1 VISIBLE;
--@queryplan
SELECT /*+ recompile */ * FROM t1 WHERE LOWER(FirstName)='yin' using index first_name_lower(+);
drop table if exists t1;
