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

create index i_t1_a2q on t1(a) where a is not null;
create index i_t1_a2p on t1(b) where b is not null;
create index i_t1_a2o on t1(c) where c is not null;
create index i_t1_a2n on t1(d) where d is not null;
create index i_t1_a2m on t1(e) where e is not null;
create index i_t1_a2l on t1(f) where f is not null;
create index i_t1_a2k on t1(g) where g is not null;
create index i_t1_a2j on t1(h) where h is not null;
create index i_t1_a2i on t1(i) where i is not null;
create index i_t1_a2h on t1(j) where j is not null;
create index i_t1_a2g on t1(k) where k is not null;
create index i_t1_a2f on t1(l) where l is not null;
create index i_t1_a2e on t1(m) where m is not null;
create index i_t1_a2d on t1(n) where n is not null;
create index i_t1_a2c on t1(o) where o is not null;
create index i_t1_a2b on t1(p) where p is not null;
create index i_t1_a2a on t1(q) where q is not null;


PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a from t1 where a is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a from t1 where a >? using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1 using '0'
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ b from t1 where b is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ b from t1 where b >? using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1 using '0'
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ c from t1 where c is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ c from t1 where c >? using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1 using N'0'
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ d from t1 where d is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ e from t1 where e is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ f from t1 where f is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ g from t1 where g is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ h from t1 where h is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ i from t1 where i is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ j from t1 where j is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ k from t1 where k is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ l from t1 where l is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ m from t1 where m is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ n from t1 where n is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ o from t1 where o is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ p from t1 where p is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ q from t1 where q is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)'
--TEST
execute stmt1
DEALLOCATE PREPARE stmt1;

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
