--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(a char(1200) DEFAULT'a',   b varchar(1200)DEFAULT 'b',  c nchar(1200) DEFAULT N'c',  d NCHAR VARYING(1200) DEFAULT N'd',  e BIT(1200)DEFAULT B'1',  f BIT VARYING(1200)DEFAULT B'0',  g int DEFAULT 0,  h SMALLINT DEFAULT 0,  i BIGINT DEFAULT 0,  j NUMERIC DEFAULT 0,  k FLOAT DEFAULT 0,  l DOUBLE DEFAULT 0,  m MONETARY DEFAULT 0,  n DATE DEFAULT '2008-10-31',  o TIME DEFAULT '13:10:30',  p TIMESTAMP DEFAULT '2010-10-31 01:15:45',  q DATETIME DEFAULT'2010-10-31 01:15:45');

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
  0,
  0,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create successfully 
create index i_t1_a2q on t1(DEFAULT(a));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where DEFAULT(a)='a';
--TEST Create successfully 
create index i_t1_a2p on t1(DEFAULT(b));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where DEFAULT(b)='b' ;
--TEST Create successfully 
create index i_t1_a2o on t1(DEFAULT(c));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where DEFAULT(c)='c' ;
--TEST Create successfully 
create index i_t1_a2n on t1(DEFAULT(d));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where DEFAULT(d)='d' ;
--TEST Create successfully 
create index i_t1_a2m on t1(DEFAULT(e));
--TEST: should use index i_t1_a2m
select /*+ RECOMPILE */* from t1 where DEFAULT(e)='1' ;
--TEST Create successfully 
create index i_t1_a2l on t1(DEFAULT(f));
--TEST: should use index i_t1_a2l
select /*+ RECOMPILE */* from t1 where DEFAULT(f)='0' ;
--TEST Create successfully 
create index i_t1_a2k on t1(DEFAULT(g));
--TEST: should use index i_t1_a2k
select /*+ RECOMPILE */* from t1 where DEFAULT(g)=0 ;
--TEST Create successfully 
create index i_t1_a2j on t1(DEFAULT(h));
--TEST: should use index i_t1_a2j
select /*+ RECOMPILE */* from t1 where DEFAULT(h)<=0 ;
--TEST Create successfully 
create index i_t1_a2i on t1(DEFAULT(i));
--TEST: should use index i_t1_a2i
select /*+ RECOMPILE */* from t1 where DEFAULT(i)>=0 ;
--TEST Create successfully 
create index i_t1_a2h on t1(DEFAULT(j));
--TEST: should use index i_t1_a2h
select /*+ RECOMPILE */* from t1 where DEFAULT(j)=0 ;
--TEST Create successfully 
create index i_t1_a2g on t1(DEFAULT(k));
--TEST: should use index i_t1_a2g
select /*+ RECOMPILE */* from t1 where DEFAULT(k)>=0 ;
--TEST Create successfully 
create index i_t1_a2f on t1(DEFAULT(l));
--TEST: should use index i_t1_a2f
select /*+ RECOMPILE */* from t1 where DEFAULT(l)=0 ;
--TEST Create successfully 
create index i_t1_a2e on t1(DEFAULT(m));
--TEST: should use index i_t1_a2e
select /*+ RECOMPILE */* from t1 where DEFAULT(m)=0 ;
--TEST Create successfully 
create index i_t1_a2d on t1(DEFAULT(n));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where DEFAULT(n)='2008-10-31' ;
--TEST Create successfully 
create index i_t1_a2c on t1(DEFAULT(o));
--TEST: should use index i_t1_a2c
select /*+ RECOMPILE */* from t1 where DEFAULT(o)='13:10:30' ;
--TEST Create successfully 
create index i_t1_a2b on t1(DEFAULT(p));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where DEFAULT(p)='2010-10-31 01:15:45' ;
--TEST Create successfully 
create index i_t1_a2a on t1(DEFAULT(q));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where DEFAULT(q)=q ;

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
