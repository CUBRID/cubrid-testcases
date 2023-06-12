set system parameters 'deduplicate_min_keys=0';

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
create view v_t1_a2q as select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o||p||q) as num1,count(c) as num2,count(d) as num3,10 num4 from t1 where exists (select t1.a) and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2q;
alter view v_t1_a2q add query select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o||p||q) as num1,count(c) as num2,count(d) as num3,10 num4 from t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2q;

--TEST: should use i_t1_a2p
create view v_t1_a2p as select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o||p) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)   and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2p;
alter view v_t1_a2p add query select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o||p) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)   and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2p;

--TEST: should use i_t1_a2o
create view v_t1_a2o as select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2o;
alter view v_t1_a2o add query select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2o;

--TEST: should use i_t1_a2n
create view v_t1_a2n as select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2n;
alter view v_t1_a2n add query  select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2n;

--TEST: should use i_t1_a2m
create view v_t1_a2m as select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2m;
alter view v_t1_a2m add query select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)   and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2m;

--TEST: should use i_t1_a2l
create view v_t1_a2l as select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2l;
alter view v_t1_a2l add query select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2l;

--TEST: should use i_t1_a2k
create view v_t1_a2k as select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2k;
alter view v_t1_a2k add query select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2k;

--TEST: should use i_t1_a2j
create view v_t1_a2j as select /*+ RECOMPILE */ count(b||e||f||g||h||i||j) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a) and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2j;
alter view v_t1_a2j add query select /*+ RECOMPILE */ count(b||e||f||g||h||i||j) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2j;

--TEST: should use i_t1_a2i
create view v_t1_a2i as select /*+ RECOMPILE */ count(b||e||f||g||h||i) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2i;
alter view v_t1_a2i add query select /*+ RECOMPILE */ count(b||e||f||g||h||i) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2i;

--TEST: should use i_t1_a2h
create view v_t1_a2h as select /*+ RECOMPILE */ count(b||e||f||g||h) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2h;
alter view v_t1_a2h add query select /*+ RECOMPILE */ count(b||e||f||g||h) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2h;

--TEST: should use i_t1_a2g
create view v_t1_a2g as select /*+ RECOMPILE */ count(b||e||f||g) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2g;
alter view v_t1_a2g add query select /*+ RECOMPILE */ count(b||e||f||g) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2g;

--TEST: should use i_t1_a2f
create view v_t1_a2f as select /*+ RECOMPILE */ count(b||e||f) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2f;
alter view v_t1_a2f add query select /*+ RECOMPILE */ count(b||e||f) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2f;

--TEST: should use i_t1_a2e
create view v_t1_a2e as select /*+ RECOMPILE */ count(b||e) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2e;
alter view v_t1_a2e add query select /*+ RECOMPILE */ count(b||e) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2e;

--TEST: should use i_t1_a2d
create view v_t1_a2d as select /*+ RECOMPILE */ count(b) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2d;
alter view v_t1_a2d add query select /*+ RECOMPILE */ count(b) as num1, count(c) as num2, count(d) as num3, 10  as num4 from   t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2d;

--TEST: should use i_t1_a2c
create view v_t1_a2c as select /*+ RECOMPILE */ count(b) as num1,count(c) as num2,10 as num3 from t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2c;
alter view v_t1_a2c add query select /*+ RECOMPILE */ count(b) as num1,count(c) as num2,10 as num3 from t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2c;

--TEST: should use i_t1_a2b
create view v_t1_a2b as select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2b;
alter view v_t1_a2b add query  select /*+ RECOMPILE */ count(b) as num1,10 as num2 from t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2b;

--TEST: should use i_t1_a2a
create view v_t1_a2a as select /*+ RECOMPILE */ 10 as num1 from t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2a;
alter view v_t1_a2a add query select /*+ RECOMPILE */ 10 as num1 from t1 where exists (select t1.a)  and a > '0';
select /*+ RECOMPILE */ * from v_t1_a2a;

drop view v_t1_a2q,v_t1_a2p,v_t1_a2o,v_t1_a2n,v_t1_a2m,v_t1_a2l,v_t1_a2k,v_t1_a2j,v_t1_a2i,v_t1_a2h,v_t1_a2g,v_t1_a2f,v_t1_a2e,v_t1_a2d,v_t1_a2c,v_t1_a2b,v_t1_a2a;
drop table t1;
set system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;

set system parameters 'deduplicate_min_keys=2';
