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


create index i_t1_a2q on t1(dayofweek(a));

create index i_t1_a2p on t1(dayofweek(b));

create index i_t1_a2o on t1(dayofweek(c));

create index i_t1_a2n on t1(dayofweek(d));

create index i_t1_a2m on t1(dayofweek(e));

create index i_t1_a2l on t1(dayofweek(f));

create index i_t1_a2k on t1(dayofweek(g));

create index i_t1_a2j on t1(dayofweek(h));

create index i_t1_a2i on t1(dayofweek(i));

create index i_t1_a2h on t1(dayofweek(j));

create index i_t1_a2g on t1(dayofweek(k));

create index i_t1_a2f on t1(dayofweek(l));

create index i_t1_a2e on t1(dayofweek(m));

create index i_t1_a2d on t1(dayofweek(n));

select /*+ RECOMPILE */* from t1 where dayofweek(n)=6 ;
 
create index i_t1_a2c on t1(dayofweek(o));

create index i_t1_a2b on t1(dayofweek(p));

select /*+ RECOMPILE */* from t1 where dayofweek(p)>=1 ;

create index i_t1_a2a on t1(dayofweek(q));

select /*+ RECOMPILE */* from t1 where dayofweek(q) <=6 ;
drop table t1;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);


create index i_t1_a2q on t1(dayofweek(a));

create index i_t1_a2p on t1(dayofweek(b));

create index i_t1_a2o on t1(dayofweek(c));

create index i_t1_a2n on t1(dayofweek(d));

create index i_t1_a2m on t1(dayofweek(e));

create index i_t1_a2l on t1(dayofweek(f));

create index i_t1_a2k on t1(dayofweek(g));

create index i_t1_a2j on t1(dayofweek(h));

create index i_t1_a2i on t1(dayofweek(i));

create index i_t1_a2h on t1(dayofweek(j));

create index i_t1_a2g on t1(dayofweek(k));

create index i_t1_a2f on t1(dayofweek(l));

create index i_t1_a2e on t1(dayofweek(m));

create index i_t1_a2d on t1(dayofweek(n));
 
create index i_t1_a2c on t1(dayofweek(o));

create index i_t1_a2b on t1(dayofweek(p));

create index i_t1_a2a on t1(dayofweek(q));


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
select /*+ RECOMPILE */* from t1 where dayofweek(n)=6 ;
select /*+ RECOMPILE */* from t1 where dayofweek(p)>=1 ;
select /*+ RECOMPILE */* from t1 where dayofweek(q) <=6 ;
drop table t1;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

create index i_t1_a2q on t1(dayofweek(a));

create index i_t1_a2p on t1(dayofweek(b));

create index i_t1_a2q on t1(dayofweek(c));

create index i_t1_a2p on t1(dayofweek(d));
create index i_t1_a2d on t1(dayofweek(n));

create index i_t1_a2b on t1(dayofweek(p));

create index i_t1_a2a on t1(dayofweek(q));
insert into t1 values (
  '2008-10-31',
  '2008-10-31',
  N'2008-10-31',
  N'2008-10-31',
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
select /*+ RECOMPILE */* from t1 where dayofweek(a)=6 ;
select /*+ RECOMPILE */* from t1 where dayofweek(b)>=1 ;
select /*+ RECOMPILE */* from t1 where dayofweek(c) <=6 ;
select /*+ RECOMPILE */* from t1 where dayofweek(d)=6 ;
select /*+ RECOMPILE */* from t1 where dayofweek(n)=6 ;
select /*+ RECOMPILE */* from t1 where dayofweek(p)>=1 ;
select /*+ RECOMPILE */* from t1 where dayofweek(q) <=6 ;
drop table t1;