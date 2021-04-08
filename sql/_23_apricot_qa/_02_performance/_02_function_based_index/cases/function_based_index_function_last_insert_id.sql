--+ holdcas on;
create table t1(a char(1200) DEFAULT'a',   b varchar(1200)DEFAULT 'b',  c nchar(1200) DEFAULT N'c',  d NCHAR VARYING(1200) DEFAULT N'd',  e BIT(1200)DEFAULT B'1',  f BIT VARYING(1200)DEFAULT B'0',  g int DEFAULT 0,  h SMALLINT DEFAULT 0,  i BIGINT DEFAULT 0,  j NUMERIC DEFAULT 0,  k FLOAT DEFAULT 0,  l DOUBLE DEFAULT 0,  m MONETARY DEFAULT 0,  n DATE DEFAULT '2008-10-31',  o TIME DEFAULT '13:10:30',  p TIMESTAMP DEFAULT '2010-10-31 01:15:45',  q DATETIME DEFAULT'2010-10-31 01:15:45');

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

--TEST Create fail 
create index i_t1_a2q on t1(last_insert_id());
create index i_t1_a2q on t1(a) where last_insert_id()=0;
--TEST: should use index i_t1_a2q
select /*+ RECOMPILE */* from t1 where last_insert_id()=1 and a>'0' ;

drop table t1;
commit;
--+ holdcas off;
