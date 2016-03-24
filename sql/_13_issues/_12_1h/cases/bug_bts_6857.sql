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


create index i_t1_a2q on t1(DATE(a));

create index i_t1_a2p on t1(DATE(b));

create index i_t1_a2o on t1(DATE(c));

create index i_t1_a2n on t1(DATE(d));

create index i_t1_a2m on t1(DATE(e));

create index i_t1_a2l on t1(DATE(f));

create index i_t1_a2k on t1(DATE(g));

create index i_t1_a2j on t1(DATE(h));

create index i_t1_a2i on t1(DATE(i));

create index i_t1_a2h on t1(DATE(j));

create index i_t1_a2g on t1(DATE(k));

create index i_t1_a2f on t1(DATE(l));

create index i_t1_a2e on t1(DATE(m));
 
create index i_t1_a2d on t1(DATE(n));

select /*+ RECOMPILE */* from t1 where DATE(n)='10/31/2008' ;
 
create index i_t1_a2c on t1(DATE(o));

create index i_t1_a2b on t1(DATE(p));

select /*+ RECOMPILE */* from t1 where DATE(p)>='10/31/2010' ;
 
create index i_t1_a2a on t1(DATE(q));

select /*+ RECOMPILE */* from t1 where (DATE(q)) <='10/31/2008' ;
drop table t1;

create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);


create index i_t1_a2q on t1(DATE(a));

create index i_t1_a2p on t1(DATE(b));

create index i_t1_a2o on t1(DATE(c));

create index i_t1_a2n on t1(DATE(d));

create index i_t1_a2m on t1(DATE(e));

create index i_t1_a2l on t1(DATE(f));

create index i_t1_a2k on t1(DATE(g));

create index i_t1_a2j on t1(DATE(h));

create index i_t1_a2i on t1(DATE(i));

create index i_t1_a2h on t1(DATE(j));

create index i_t1_a2g on t1(DATE(k));

create index i_t1_a2f on t1(DATE(l));

create index i_t1_a2e on t1(DATE(m));
 
create index i_t1_a2d on t1(DATE(n));

select /*+ RECOMPILE */* from t1 where DATE(n)='10/31/2008' ;
 
create index i_t1_a2c on t1(DATE(o));

create index i_t1_a2b on t1(DATE(p));

select /*+ RECOMPILE */* from t1 where DATE(p)>='10/31/2010' ;

create index i_t1_a2a on t1(DATE(q));

select /*+ RECOMPILE */* from t1 where (DATE(q)) <='10/31/2008' ;
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
drop table t1;