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

create index i_t1_a2q on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q) where b is not null;
create index i_t1_a2p on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p) where b is not null;
create index i_t1_a2o on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o) where b is not null;
create index i_t1_a2n on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n) where b is not null;
create index i_t1_a2m on t1(a,b,c,d,e,f,g,h,i,j,k,l,m) where b is not null;
create index i_t1_a2l on t1(a,b,c,d,e,f,g,h,i,j,k,l) where b is not null;
create index i_t1_a2k on t1(a,b,c,d,e,f,g,h,i,j,k) where b is not null;
create index i_t1_a2j on t1(a,b,c,d,e,f,g,h,i,j) where b is not null;
create index i_t1_a2i on t1(a,b,c,d,e,f,g,h,i) where b is not null;
create index i_t1_a2h on t1(a,b,c,d,e,f,g,h) where b is not null;
create index i_t1_a2g on t1(a,b,c,d,e,f,g) where b is not null;
create index i_t1_a2f on t1(a,b,c,d,e,f) where b is not null;
create index i_t1_a2e on t1(a,b,c,d,e) where b is not null;
create index i_t1_a2d on t1(a,b,c,d) where b is not null;
create index i_t1_a2c on t1(a,b,c) where b is not null;
create index i_t1_a2b on t1(a,b) where b is not null;
create index i_t1_a2a on t1(a) where b is not null;


PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a>? and b is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;
PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a>? using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p from t1 where a>? and b is not null using index i_t1_a2p(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i,j,k,l,m,n,o from t1 where a>? and b is not null using index i_t1_a2o(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i,j,k,l,m,n from t1 where a>? and b is not null using index i_t1_a2n(+) ';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i,j,k,l,m from t1 where a>? and b is not null using index i_t1_a2m(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i,j,k,l from t1 where a>? and b is not null using index i_t1_a2l(+) ';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i,j,k from t1 where a>? and b is not null using index i_t1_a2k(+) ';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i,j from t1 where a>? and b is not null using index i_t1_a2j(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h,i from t1 where a>? and b is not null using index i_t1_a2i(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g,h from t1 where a>? and b is not null using index i_t1_a2h(+) ';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f,g from t1 where a>? and b is not null using index i_t1_a2g(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e,f from t1 where a>? and b is not null using index i_t1_a2f(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d,e from t1 where a>? and b is not null using index i_t1_a2e(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c,d from t1 where a>? and b is not null using index i_t1_a2d(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b,c from t1 where a>? and b is not null using index i_t1_a2c(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a,b from t1 where a>? and b is not null using index i_t1_a2b(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a from t1 where a>? and b is not null using index i_t1_a2a(+),i_t1_a2b(+),i_t1_a2c(+),i_t1_a2d(+),i_t1_a2e(+),i_t1_a2f(+),i_t1_a2g(+),i_t1_a2h(+),i_t1_a2i(+),i_t1_a2j(+),i_t1_a2k(+),i_t1_a2l(+),i_t1_a2m(+),i_t1_a2n(+),i_t1_a2o(+),i_t1_a2p(+),i_t1_a2q(+) ';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a from t1 where a>? and b is not null using index i_t1_a2a(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

PREPARE stmt1 FROM 'select /*+ RECOMPILE */ a from t1 where a>? and c is not null using index i_t1_a2a(+)';
--TEST
execute stmt1 using '0';
DEALLOCATE PREPARE stmt1;

drop table t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
