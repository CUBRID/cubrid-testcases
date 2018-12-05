--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
drop table if exists t1;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  
    e BIT(1200),  f BIT VARYING(1200),  
    g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  
    n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

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

create index i_t1_a2q on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q)  where a>'0';
create index i_t1_a2p on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)  where a>'0';
create index i_t1_a2o on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o)  where a>'0';
create index i_t1_a2n on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n)  where a>'0';
create index i_t1_a2m on t1(a,b,c,d,e,f,g,h,i,j,k,l,m)  where a>'0';
create index i_t1_a2l on t1(a,b,c,d,e,f,g,h,i,j,k,l)  where a>'0';
create index i_t1_a2k on t1(a,b,c,d,e,f,g,h,i,j,k)  where a>'0';
create index i_t1_a2j on t1(a,b,c,d,e,f,g,h,i,j)  where a>'0';
create index i_t1_a2i on t1(a,b,c,d,e,f,g,h,i)  where a>'0';
create index i_t1_a2h on t1(a,b,c,d,e,f,g,h)  where a>'0';
create index i_t1_a2g on t1(a,b,c,d,e,f,g)  where a>'0';
create index i_t1_a2f on t1(a,b,c,d,e,f)  where a>'0';
create index i_t1_a2e on t1(a,b,c,d,e)  where a>'0';
create index i_t1_a2d on t1(a,b,c,d)  where a>'0';
create index i_t1_a2c on t1(a,b,c)  where d>'0';
create index i_t1_a2b on t1(a,b)  where a>'0';
create index i_t1_a2a on t1(a)  where a>'0';

insert into t1(g) values(5); 
with cte1(col1,col2,col3,col4,col5) as
(
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o||p||q),
count(c),count(d),10, (select count(a)) from t1  where a>'0' using index i_t1_a2q(+)
) update t1 set h=(select col1 from cte1),i=(select col2 from cte1),
  j=(select col3 from cte1),k=(select col4 from cte1),l=(select col5 from cte1) where g=5;

select * from t1 where g=5;

--TEST: should use i_t1_a2p
with cte1(col1,col2,col3,col4,col5) as
(
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o||p),
count(c),count(d),10, (select count(a)) from t1  where a>'0'using index i_t1_a2p(+)
) update t1 set h=(select col1 from cte1),i=(select col2 from cte1),j=(select col3 from cte1),k=(select col4 from cte1),l=(select col5 from cte1) where g=5;

select * from t1 where g=5;


with cte1(col1,col2,col3,col4,col5) as
(
--TEST: should use i_t1_a2o
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n||o),
count(c),count(d),10, (select count(a)) from t1  where a>'0'using index i_t1_a2o(+)
) update t1 set h=(select col1 from cte1),i=(select col2 from cte1),
j=(select col3 from cte1),k=(select col4 from cte1),l=(select col5 from cte1) where g=5;

select * from t1 where g=5;

--TEST: should use i_t1_a2n
with cte1(col1,col2,col3,col4,col5) as
(
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m||n),
count(c),count(d),10, (select count(a)) from t1  where a>'0'using index i_t1_a2n(+)
)
update t1 set h=(select col1 from cte1),i=(select col2 from cte1),
j=(select col3 from cte1),k=(select col4 from cte1),l=(select col5 from cte1) where g=5;

select * from t1 where g=5;

--TEST: should use i_t1_a2m
with cte1(col1,col2,col3,col4,col5) as
(
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l||m),
count(c),count(d),10, (select count(a)) from t1  where a>'0'using index i_t1_a2m(+)
)update t1 set h=(select col1 from cte1),i=(select col2 from cte1),
j=(select col3 from cte1),k=(select col4 from cte1),l=(select col5 from cte1) where g=5;

select * from t1 where g=5;


--TEST: should use i_t1_a2l
with cte1(col1,col2,col3,col4,col5) as
(
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k||l),
count(c),count(d),10, (select count(a)) from t1  where a>'0'using index i_t1_a2l(+)
) update t1 set h=(select col1 from cte1),i=(select col2 from cte1),
j=(select col3 from cte1),k=(select col4 from cte1),l=(select col5 from cte1) where g=5;

select * from t1 where g=5;


--TEST: should use i_t1_a2k
with cte1(col1,col2,col3,col4,col5) as
(
select /*+ RECOMPILE */ count(b||e||f||g||h||i||j||k),
count(c),count(d),10, (select count(a)) from t1  where a>'0'using index i_t1_a2k(+)
) update t1 set h=(select col1 from cte1),i=(select col2 from cte1),
j=(select col3 from cte1),k=(select col4 from cte1),l=(select col5 from cte1) where g=5;
select * from t1 where g=5;

drop table if exists t1;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
