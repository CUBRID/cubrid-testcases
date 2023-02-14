--CBRD-22617 Core dumped in qo_get_attr_info_func_index at src/optimizer/query_graph.c:4921

drop table if exists foo;
create table foo (a char(10), b varchar(10));
create index idx_foo_weekday_a on foo (weekday(a)) invisible;
create index idx_foo_weekday_b on foo (weekday(b)) invisible;
SHOW INDEXES from foo;
insert into foo values ('2010-01-01','2011-01-01');
insert into foo values ('2010-01-02','2011-01-02');
insert into foo values ('2010-01-03','2011-01-03');
insert into foo values ('2010-01-04','2011-01-04');
insert into foo values ('2010-01-05','2011-01-05');
update statistics on foo;
--@queryplan
select * from foo where weekday(a) >= 4 order by a;
--@queryplan
select * from foo where weekday(b) >= 4 order by b;
alter table foo drop column b;
update statistics on foo;
SHOW INDEXES from foo;
insert into foo values ('abc');
drop index idx_foo_weekday_a on foo;
truncate foo;
insert into foo values ('abc');
create index idx_foo_weekday_a on foo (weekday(a)) invisible;
drop table if exists foo;

create table foo (a int);
create index idx_foo_trunc on foo (TRUNC (a, -1));
SHOW INDEXES from foo;
insert into foo values (7), (15), (2200), (7001), (178), (4);
--@queryplan
select /*+ recompile */ * from foo where TRUNC (a, -1) > 0 order by a;
alter index idx_foo_trunc on foo invisible;
--@queryplan
select /*+ recompile */ * from foo where TRUNC (a, -1) > 0 order by a;
drop foo;

create table foo (a char(5));
create index idx_foo_abs on foo (abs(-a));
SHOW INDEXES from foo;
insert into foo values ('5'), ('11'), ('-1');
select /*+ recompile */ * from foo where abs(-a) > 0 order by a;
alter index idx_foo_abs on foo invisible;
update statistics on foo;
SHOW INDEXES from foo;
--@queryplan
select /*+ recompile */ * from foo where abs(-a) > 0 order by a;
drop foo;

create table foo (str string, c1 char, c2 char);
insert into foo values ('abcabc','a','d');
insert into foo values ('xyzxyz','a','x');
create index idx_foo_translate on foo (translate(str,c1,c2));
update statistics on foo;
SHOW INDEXES from foo;
--@queryplan
select /*+ recompile */ str original, translate(str,c1,c2) translated from foo where translate(str,c1,c2) in ('dbcdbc','smthsmth');
alter index idx_foo_translate on foo invisible;
update statistics on foo;
SHOW INDEXES from foo;
--@queryplan
select /*+ recompile */ str original, translate(str,c1,c2) translated from foo where translate(str,c1,c2) in ('dbcdbc','smthsmth');
drop foo;

-- check function holder
create table foo (a string, b string, c string);
insert into foo values ('aaa','bbb','ccc');
insert into foo values ('bbb','ccc','aaa');
insert into foo values ('ccc','aaa','bbb');
create index idx_foo_elt on foo (ELT (3, a, b, c)) invisible;
update statistics on foo;
SHOW INDEXES from foo;
select /*+ recompile */ * from foo where ELT(3, a, b, c) > 'aaa';
drop foo;

drop table if exists t;
create table t(a char(1200));
insert into t value('1234567890');
select * from t where UPPER(a)='1234567890' ;
create index idx on t(UPPER(a)) invisible;
select * from t where UPPER(a)='1234567890' ;
drop table t;

drop table if exists t1;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE
,  o TIME,  p TIMESTAMP,  q DATETIME);
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
create index i_t1_a2d on t1(DATE(n)) invisible;
select /*+ RECOMPILE */* from t1 where DATE(n)='10/31/2008' ;
create index i_t1_a2q on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q) invisible;
create index i_t1_a2p on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) with online invisible;
update statistics on t1;
show index from t1;
create index i_t1_a2q on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q);
create index i_t1_a2p on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) with online ;
update statistics on t1;
show index from t1;
drop table if exists t1;
