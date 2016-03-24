create table t(a char(1200),   b varchar(1200),  c int,d smallint);
create index idx on t(insert(a,c,d,b));
drop t;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '1234567890',
  '1234567890',
  N'ABC',
  N'abc',
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


create index i_t1_a2q on t1(insert(a,1,2,b));

select /*+ RECOMPILE */* from t1 where insert(a,1,2,b)='111112' ;

create index i_t1_a2p on t1(insert(a,g,h,c));

select /*+ RECOMPILE */* from t1 where insert(a,g,h,c)>='1234567890' ;

create index i_t1_a2o on t1(insert(o,1,3,n));

create index i_t1_a2n on t1(insert(p,h,i,q));

create index i_t1_a2m on t1(insert(a,b,c,d));

create index i_t1_a2l on t1(insert(a,e,g,b));

create index i_t1_a2k on t1(insert(d,f,g,p));

create index i_t1_a2j on t1(insert(g,h,2,i));

create index i_t1_a2i on t1(insert(g,k,i,l));

drop table t1;