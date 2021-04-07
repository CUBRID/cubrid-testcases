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
  254,
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

create index i_t1_a2q on t1(a) where a='1234567890';
create index i_t1_a2p on t1(b) where b='1234567890';
create index i_t1_a2o on t1(c) where c=N'abc';
create index i_t1_a2n on t1(d) where d=N'ABC';
create index i_t1_a2m on t1(e) where e=B'1111111111';
create index i_t1_a2l on t1(f) where f=B'1111111111';
create index i_t1_a2k on t1(g) where g>9;
create index i_t1_a2j on t1(h) where h<255;
create index i_t1_a2i on t1(i) where i<>9223372036854775806;
create index i_t1_a2h on t1(j) where j=0;
create index i_t1_a2g on t1(k) where j=0;
create index i_t1_a2f on t1(l) where l=0;
create index i_t1_a2e on t1(m) where m<=0;
create index i_t1_a2d on t1(n) where n=DATE '2008-10-31';
create index i_t1_a2c on t1(o) where o=TIME '00:00:00';
create index i_t1_a2b on t1(p) where p=TIMESTAMP '2010-10-31 01:15:45';
create index i_t1_a2a on t1(q) where q=DATETIME  '2008-10-31 13:15:45';

insert into t1 select a,b,c,d,e,f,g+10,h,i,j,k,l,m,n,o,p,q from t1;

--TEST:
select /*+ recompile */ * from (select /*+ RECOMPILE */ a from t1 where a='1234567890'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ b from t1 where b='1234567890'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ c from t1 where c=N'abc'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ d from t1 where d=N'ABC'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ e from t1 where e=B'1111111111'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ f from t1 where f=B'1111111111'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ g from t1 where g=10   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ h from t1 where h=254   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ i from t1 where i=9223372036854775807   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ j from t1 where j=0   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ k from t1 where j=0   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ l from t1 where l=0   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ m from t1 where m=-100   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ n from t1 where n=DATE '2008-10-31'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ o from t1 where o=TIME '00:00:00'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ p from t1 where p=TIMESTAMP '2010-10-31 01:15:45'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;
select /*+ recompile */ * from (select /*+ RECOMPILE */ q from t1 where q=DATETIME  '2008-10-31 13:15:45'   using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)) t order by 1;

drop table t1;

commit;
--+ holdcas off;
