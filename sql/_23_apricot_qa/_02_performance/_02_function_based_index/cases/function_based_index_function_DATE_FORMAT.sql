--+ holdcas on;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '2009-10-04 22:23:00',
  '2007-10-04 22:23:00',
  N'1900-10-04 22:23:00',
  N'1999-01-01',
  B'1111111111',
  B'1111111111',
  10,
  255,
  9223372036854775807,
  0,
  1.5678,
  -12.5678,
  -24,
  DATE '1999-01-01',
  TIME '22:23:00',
  TIMESTAMP '1900-10-04 22:23:00',
  DATETIME  '2009-10-04 22:23:00');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

--TEST Create successfully 
create index i_t1_a2q on t1(DATE_FORMAT(a,'%W %M %Y'));
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where DATE_FORMAT(a,'%W %M %Y')='Sunday October 2009';
--TEST Create successfully 
create index i_t1_a2p on t1(DATE_FORMAT(b, '%H:%i:%s'));
--TEST: should use index i_t1_a2p
select /*+ RECOMPILE */* from t1 where DATE_FORMAT(b, '%H:%i:%s')='22:23:00' ;
--TEST Create successfully 
create index i_t1_a2o on t1(DATE_FORMAT(c,'%D %y %a %d %m %b %j'));
--TEST: should use index i_t1_a2o
select /*+ RECOMPILE */* from t1 where DATE_FORMAT(c,'%D %y %a %d %m %b %j')='4th 00 Thu 04 10 Oct 277' ;
--TEST Create successfully 
create index i_t1_a2n on t1(DATE_FORMAT(d, '%X %V'));
--TEST: should use index i_t1_a2n
select /*+ RECOMPILE */* from t1 where DATE_FORMAT(d, '%X %V')='1998 52' ;
--TEST Create failed 
create index i_t1_a2m on t1(DATE_FORMAT(e,'%W %M %Y'));
--TEST Create failed 
create index i_t1_a2l on t1(DATE_FORMAT(f,'%W %M %Y'));
--TEST Create failed 
create index i_t1_a2k on t1(DATE_FORMAT(g,'%W %M %Y'));
--TEST Create failed 
create index i_t1_a2j on t1(DATE_FORMAT(h,'%W %M %Y'));
--TEST Create failed 
create index i_t1_a2i on t1(DATE_FORMAT(i,'%W %M %Y'));
--TEST Create failed 
create index i_t1_a2h on t1(DATE_FORMAT(j,'%W %M %Y'));
--TEST Create failed 
create index i_t1_a2g on t1(DATE_FORMAT(k,'%W %M %Y'));
--TEST Create failed 
create index i_t1_a2f on t1(DATE_FORMAT(l,'%W %M %Y'));
--TEST Create failed 
create index i_t1_a2e on t1(DATE_FORMAT(m,'%W %M %Y'));
--TEST Create successfully  
create index i_t1_a2d on t1(DATE_FORMAT(n,'%X %V'));
--TEST: should use index i_t1_a2d
select /*+ RECOMPILE */* from t1 where DATE_FORMAT(n,'%X %V')='1998 52' ;
--TEST Create failed 
create index i_t1_a2c on t1(DATE_FORMAT(o,'%H:%i:%s'));
--TEST Create successfully  
create index i_t1_a2b on t1(DATE_FORMAT(p,'%D %y %a %d %m %b %j'));
--TEST: should use index i_t1_a2b
select /*+ RECOMPILE */* from t1 where DATE_FORMAT(p,'%D %y %a %d %m %b %j')>='4th 00 Thu 04 10 Oct 277' ;
--TEST Create successfully  
create index i_t1_a2a on t1(DATE_FORMAT(q,'%W %M %Y'));
--TEST: should use index i_t1_a2a
select /*+ RECOMPILE */* from t1 where DATE_FORMAT(q,'%W %M %Y') <='Sunday October 2009' ;
drop table t1;
commit;
--+ holdcas off;
