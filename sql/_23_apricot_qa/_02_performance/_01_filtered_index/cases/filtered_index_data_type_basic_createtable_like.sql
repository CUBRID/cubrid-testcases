set system parameters 'deduplicate_min_keys=0';

--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
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

create index i_t1_a2q on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q) where q > TIMESTAMP '2010-10-31 01:15:50';
create index i_t1_a2p on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) where b>'0234567800';
create index i_t1_a2o on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o) where a > '0234567800';
create index i_t1_a2n on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n) where g > -1;
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

create table t2 like t1;
--TEST
insert into t2 select * from t1;
--TEST using index i_t1_a2b
select /*+ RECOMPILE */ count(*) from t2 where a>'0' and b>'0234567890' using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);
--TEST using index i_t1_a2p
select /*+ RECOMPILE */ count(*) from t2 where a>'0' and b>'0234567890' using index i_t1_a2p;
--TEST using index i_t1_a2b
select /*+ RECOMPILE */ count(*) from t2 where a>'0' and b>'0234567890';
--TEST using index i_t1_a2a
select /*+ RECOMPILE */ a from t2 where a > '0234567890' using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);
--TEST using index i_t1_a2b
select /*+ RECOMPILE */ a from t2 where a > '0234567890' using index i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);
--TEST using index i_t1_a2g
select /*+ RECOMPILE */ g from t2 where  a>'0' and g > -1 using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);
--TEST using index i_t1_a2q 
select /*+ RECOMPILE */ q from t2 where a>'0'  and q > TIMESTAMP '2010-10-31 01:15:50' using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+);

drop table t1;
drop table t2;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

set system parameters 'deduplicate_min_keys=2';
