set system parameters 'deduplicate_key_level=0';

--+ holdcas on;
set system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

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

create index i_t1_a2q on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q);
create index i_t1_a2p on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p);
create index i_t1_a2o on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o);
create index i_t1_a2n on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n);
create index i_t1_a2m on t1(a,b,c,d,e,f,g,h,i,j,k,l,m);
create index i_t1_a2l on t1(a,b,c,d,e,f,g,h,i,j,k,l);
create index i_t1_a2k on t1(a,b,c,d,e,f,g,h,i,j,k);
create index i_t1_a2j on t1(a,b,c,d,e,f,g,h,i,j);
create index i_t1_a2i on t1(a,b,c,d,e,f,g,h,i);
create index i_t1_a2h on t1(a,b,c,d,e,f,g,h);
create index i_t1_a2g on t1(a,b,c,d,e,f,g);
create index i_t1_a2f on t1(a,b,c,d,e,f);
create index i_t1_a2e on t1(a,b,c,d,e);
create index i_t1_a2d on t1(a,b,c,d);
create index i_t1_a2c on t1(a,b,c);
create index i_t1_a2b on t1(a,b);
create index i_t1_a2a on t1(a);

--TEST: should use i_t1_a2q
select /*+ RECOMPILE */ count(a||b||e||f||g||h||i||j||k||l||m||n||o||p||q),count(c),count(d) from t1 where a>'0';

--TEST: should use i_t1_a2p
select /*+ RECOMPILE */ count(a||b||e||f||g||h||i||j||k||l||m||n||o||p),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2o
select /*+ RECOMPILE */ count(a||b||e||f||g||h||i||j||k||l||m||n||o),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2n
select /*+ RECOMPILE */ count(a||b||e||f||g||h||i||j||k||l||m||n),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2m
select /*+ RECOMPILE */ count(a||b||e||f||g||h||i||j||k||l||m),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2l
select /*+ RECOMPILE */ count(a||b||e||f||g||h||i||j||k||l),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2k
select /*+ RECOMPILE */ count(a||b||e||f||g||h||i||j||k),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2j
select /*+ RECOMPILE */ count(a||b||e||f||g||h||i||j),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2i
select /*+ RECOMPILE */ count(a||b||e||f||g||h||i),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2h
select /*+ RECOMPILE */ count(a||b||e||f||g||h),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2g
select /*+ RECOMPILE */ count(a||b||e||f||g),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2f
select /*+ RECOMPILE */ count(a||b||e||f),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2e
select /*+ RECOMPILE */ count(a||b||e),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2d
select /*+ RECOMPILE */ count(a||b),count(c),count(d) from t1  where a>'0';

--TEST: should use i_t1_a2c
select /*+ RECOMPILE */ count(a||b),count(c) from t1  where a>'0';

--TEST: should use i_t1_a2b
select /*+ RECOMPILE */ count(a||b) from t1  where a>'0';

--TEST: should use i_t1_a2a
select /*+ RECOMPILE */ count(a) from t1  where a>'0';



drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

set system parameters 'deduplicate_key_level=32';
