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
create index i_t1_a2p on t1(MINUTE(b));
create index i_t1_a2o on t1(MINUTE(c));
create index i_t1_a2n on t1(MINUTE(d));
create index i_t1_a2m on t1(MINUTE(e));
create index i_t1_a2l on t1(MINUTE(f));
create index i_t1_a2k on t1(MINUTE(g));
create index i_t1_a2j on t1(MINUTE(h));
create index i_t1_a2i on t1(MINUTE(i));
create index i_t1_a2h on t1(MINUTE(j));
create index i_t1_a2g on t1(MINUTE(k));
create index i_t1_a2f on t1(MINUTE(l));
create index i_t1_a2e on t1(MINUTE(m));  
create index i_t1_a2d on t1(MINUTE(n));
select /*+ RECOMPILE */* from t1 where MINUTE(n)=0 ;  
create index i_t1_a2c on t1(MINUTE(o));
select /*+ RECOMPILE */* from t1 where MINUTE(o)=0 ; 
create index i_t1_a2b on t1(MINUTE(p));
select /*+ RECOMPILE */* from t1 where MINUTE(p)>=15 ; 
create index i_t1_a2a on t1(MINUTE(q));
select /*+ RECOMPILE */* from t1 where MINUTE(q) <=15 ;
drop table t1;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

create index i_t1_a2q on t1(MINUTE(a));
create index i_t1_a2p on t1(MINUTE(b));
create index i_t1_a2o on t1(MINUTE(c));
create index i_t1_a2n on t1(MINUTE(d));
create index i_t1_a2m on t1(MINUTE(e));
create index i_t1_a2l on t1(MINUTE(f));
create index i_t1_a2k on t1(MINUTE(g));
create index i_t1_a2j on t1(MINUTE(h));
create index i_t1_a2i on t1(MINUTE(i));
create index i_t1_a2h on t1(MINUTE(j));
create index i_t1_a2g on t1(MINUTE(k));
create index i_t1_a2f on t1(MINUTE(l));
create index i_t1_a2e on t1(MINUTE(m));  
create index i_t1_a2d on t1(MINUTE(n)); 
create index i_t1_a2c on t1(MINUTE(o)); 
create index i_t1_a2b on t1(MINUTE(p));
create index i_t1_a2a on t1(MINUTE(q));


insert into t1 values (
  '13:15:45',
  '13:15:45',
  N'13:15:45',
  N'13:15:45',
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');

  insert into t1 values (
  '13:15:45',
  '13:15:45',
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  null,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
  select /*+ RECOMPILE */* from t1 where MINUTE(a)>=15 ; 
  select /*+ RECOMPILE */* from t1 where MINUTE(b>=15 ; 
  select /*+ RECOMPILE */* from t1 where MINUTE(n)=0 ;  
  select /*+ RECOMPILE */* from t1 where MINUTE(o)=0 ;
  select /*+ RECOMPILE */* from t1 where MINUTE(p)>=15 ; 
  select /*+ RECOMPILE */* from t1 where MINUTE(q) <=15 ;
drop table t1;