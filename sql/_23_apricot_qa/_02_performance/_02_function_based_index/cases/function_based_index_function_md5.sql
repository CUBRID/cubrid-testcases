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
create index i_t1_a2q on t1(md5(a));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where md5(a)='e8ddcfee3a0272e3c9e2fcfdb7f1d4b8' ;
--TEST Create successfully 
create index i_t1_a2p on t1(md5(b));
--TEST: should use both index i_t1_a2p and i_t1_a2q
select /*+ RECOMPILE */* from t1 where md5(b)='0' ;
--TEST Create successfully 
create index i_t1_a2o on t1(md5(c));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where md5(c)>'0' ;
--TEST Create successfully 
create index i_t1_a2n on t1(md5(d));
--TEST Create failed 
create index i_t1_a2m on t1(md5(e));
create index i_t1_a2l on t1(md5(f));
create index i_t1_a2k on t1(md5(g));
create index i_t1_a2j on t1(md5(h));
create index i_t1_a2i on t1(md5(i));
create index i_t1_a2h on t1(md5(j));
create index i_t1_a2g on t1(md5(k));
create index i_t1_a2f on t1(md5(l));
create index i_t1_a2e on t1(md5(m));
create index i_t1_a2d on t1(md5(n));
create index i_t1_a2c on t1(md5(o));
create index i_t1_a2b on t1(md5(p));
create index i_t1_a2a on t1(md5(q));


drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
