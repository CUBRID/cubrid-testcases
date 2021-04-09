--+ holdcas on;
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

create index i_t1_a2q on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q) where a>'0';
create index i_t1_a2p on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) where a>'0';
create index i_t1_a2o on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o) where a>'0';
create index i_t1_a2n on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n) where a>'0';
create index i_t1_a2m on t1(a,b,c,d,e,f,g,h,i,j,k,l,m) where a>'0';
create index i_t1_a2l on t1(a,b,c,d,e,f,g,h,i,j,k,l) where a>'0';
create index i_t1_a2k on t1(a,b,c,d,e,f,g,h,i,j,k) where a>'0';
create index i_t1_a2j on t1(a,b,c,d,e,f,g,h,i,j) where a>'0';
create index i_t1_a2i on t1(a,b,c,d,e,f,g,h,i) where a>'0';
create index i_t1_a2h on t1(a,b,c,d,e,f,g,h) where a>'0';
create index i_t1_a2g on t1(a,b,c,d,e,f,g) where a>'0';
create index i_t1_a2f on t1(a,b,c,d,e,f) where a>'0';
create index i_t1_a2e on t1(a,b,c,d,e) where a>'0';
create index i_t1_a2d on t1(a,b,c,d) where a>'0';
create index i_t1_a2c on t1(a,b,c) where a>'0';
create index i_t1_a2b on t1(a,b) where a>'0';
create index i_t1_a2a on t1(a) where a>'0';

--TEST: should use i_t1_a2q
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o||p||q),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2p
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o||p),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2o
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2n
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2m
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2l
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2k
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2j
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2i
select /*+ RECOMPILE */ count(b||e||f||g||h||i),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2h
select /*+ RECOMPILE */ count(b||e||f||g||h),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2g
select /*+ RECOMPILE */ count(b||e||f||g),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2f
select /*+ RECOMPILE */ count(b||e||f),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2e
select /*+ RECOMPILE */ count(b||e),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2d
select /*+ RECOMPILE */ count(b),count(c),count(d),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2c
select /*+ RECOMPILE */ count(b),count(c),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2b
select /*+ RECOMPILE */ count(b),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

--TEST: should use i_t1_a2a
select /*+ RECOMPILE */ count(length(a)),10 from t1 where exists (select t1.a) and a>'0'  using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

drop table t1;
commit;
--+ holdcas off;
