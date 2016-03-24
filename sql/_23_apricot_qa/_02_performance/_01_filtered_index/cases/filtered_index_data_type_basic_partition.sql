--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int unique,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME)
PARTITION BY RANGE (g)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20));

insert into t1 values (
  '1234567890',
  '1234567890',
  N'abc',
  N'ABC',
  B'1111111111',
  B'1111111111',
  9,
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
insert into t1 values (null,null,null,null,null,null,8,null,null,null,null,null,null,null,null,null,null);


create index i_t1_a1 on t1(a);
create index i_t1_b1 on t1(b) where b='1234567890';
create index i_t1_c1 on t1(c) where c=N'abc';
create index i_t1_d1 on t1(d) where d=N'ABC';
create index i_t1_e1 on t1(e) where f=B'1111111111';
create index i_t1_f1 on t1(f) where e=B'1111111111';
create index i_t1_e1 on t1(e) where e=B'1111111111';
create index i_t1_f1 on t1(f) where f=B'1111111111';
create index i_t1_g1 on t1(g,h) where g>10;
create index i_t1_h1 on t1(h) where h>=255;
create index i_t1_i1 on t1(i) where i=9223372036854775807;
create index i_t1_j1 on t1(j) where 0=0;
create index i_t1_k1 on t1(k) where k=0;
create index i_t1_l1 on t1(l) where l=0;
create index i_t1_m1 on t1(m) where m=-100;
create index i_t1_n1 on t1(n) where n=DATE '2008-10-31';
create index i_t1_o1 on t1(o) where o=TIME '00:00:00';
create index i_t1_p1 on t1(p) where p=TIMESTAMP '2010-10-31 01:15:45';
create index i_t1_q1 on t1(q) where q=DATETIME  '2008-10-31 13:15:45';

insert into t1 select a,b,c,d,e,f,g+10,h,i,j,k,l,m,n,o,p,q from t1;

--TEST:
select /*+ RECOMPILE */ b from t1 where b='1234567890' using index i_t1_b1(+);
select /*+ RECOMPILE */ c from t1 where c=N'abc'using index i_t1_c1(+);
select /*+ RECOMPILE */ d from t1 where d=N'ABC' using index i_t1_d1(+);
select /*+ RECOMPILE */ e from t1 where f=B'1111111111' using index i_t1_e1(+),i_t1_f1(+);
select /*+ RECOMPILE */ f from t1 where e=B'1111111111' using index i_t1_e1(+),i_t1_f1(+);
select /*+ recompile */ g,h from t1 where g>10 using index i_t1_g1(+) order by 1 ;
select /*+ recompile */ g,h from t1 where g>10 or g<10 using index i_t1_g1(+) order by 1 ;
select /*+ RECOMPILE */ h from t1 where h>=255 using index i_t1_h1(+);
select /*+ recompile */ i from t1 where i=9223372036854775807 using index i_t1_i1(+);
select /*+ RECOMPILE */ j from t1 where j=0 using index i_t1_j1(+);
select /*+ RECOMPILE */ k from t1 where k=0 using index i_t1_k1(+);
select /*+ RECOMPILE */ l from t1 where l=0 using index i_t1_l1(+);
select /*+ RECOMPILE */ m from t1 where m=-100 using index i_t1_m1(+);
select /*+ RECOMPILE */ n from t1 where n=DATE '2008-10-31' using index i_t1_n1(+);
select /*+ RECOMPILE */ o from t1 where o=TIME '00:00:00' using index i_t1_o1(+);
select /*+ RECOMPILE */ p from t1 where p=TIMESTAMP '2010-10-31 01:15:45' using index i_t1_p1(+);
select /*+ RECOMPILE */ q from t1 where q=DATETIME  '2008-10-31 13:15:45' using index i_t1_q1(+);

drop table t1;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
