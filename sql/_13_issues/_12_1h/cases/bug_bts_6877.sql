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
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);


create index i_t1_a2q on t1(POSITION(a in '12345678901'));
select /*+ RECOMPILE */* from t1 where POSITION(a in '12345678901')=1 ;
create index i_t1_a2p on t1(POSITION(a in b));
select /*+ RECOMPILE */* from t1 where POSITION(a in b)<=1 ;
create index i_t1_a2o on t1(POSITION(c in d));
select /*+ RECOMPILE */* from t1 where POSITION(c in d)<=0 ;
create index i_t1_a2n on t1(POSITION(d in c));
select /*+ RECOMPILE */* from t1 where POSITION(d in c)>1 ;
create index i_t1_a2m on t1(POSITION(e in B'111111111111'));
select /*+ RECOMPILE */* from t1 where POSITION(e in B'111111111111')<=2 ;
create index i_t1_a2l on t1(POSITION(f in e));

create index i_t1_a2k on t1(POSITION(g in a));

create index i_t1_a2j on t1(POSITION(h in a));

create index i_t1_a2i on t1(POSITION(i in a));

create index i_t1_a2h on t1(POSITION(j in a));

create index i_t1_a2g on t1(POSITION(k in a));

create index i_t1_a2f on t1(POSITION(l in a));

create index i_t1_a2e on t1(POSITION(m in a));

create index i_t1_a2d on t1(POSITION(n in a));

create index i_t1_a2c on t1(POSITION(o in a));

create index i_t1_a2b on t1(POSITION(p in a));

create index i_t1_a2a on t1(POSITION(q in a));

drop table t1;