--02_if_not_exists_from_trunk_cases_001.sql
--./_18_index_enhancement_qa/_02_full_test/_02_using_index/cases/_t111_10_keylimit_createtable_asselect.sql
drop class if exists t1,t2;
CREATE TABLE t1 (
   a  INT NOT NULL,
   b  VARCHAR(40) NOT NULL,
   c  CHAR(3)
  );
CREATE UNIQUE INDEX idx_t1_ac ON t1(a,c);
CREATE INDEX idx_t1_abc ON t1(a,b,c);

insert into t1 values (1, 'Adalius', '086');
insert into t1 values (2, 'Agassi', '086');
insert into t1 values (3, 'Ahman', '086');
insert into t1 values (4, 'Alcott', '086');
insert into t1 values (5, 'Ali', '086');
insert into t1 values (6, 'Bdalius', '011');
insert into t1 values (7, 'Bgassi', '011');
insert into t1 values (8, 'Bhman', '011');
insert into t1 values (9, 'Blcott', '011');
insert into t1 values (10, 'Bli', '011');

--TEST:

create table if not exists t2 as select * from t1 where a>0 and c='086' using index idx_t1_ac kEyLiMiT 2,4;
desc t2;
create table if not exists t2 as select * from t1 where a>0 and c='086' using index idx_t1_ac kEyLiMiT 2,4;
desc t2;

drop class if exists t1,t2;


--./_18_index_enhancement_qa/_02_full_test/_02_using_index/cases/_t111_13_keylimit_view.sql

drop class if exists t1,t2;
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int unique,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME)
PARTITION BY RANGE (g)
(PARTITION before_10 VALUES LESS THAN (10),
PARTITION before_20 VALUES LESS THAN (20),
PARTITION before_10000 VALUES LESS THAN (10000));

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

create index idx_t1_all on t1(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q);

insert into t1 select a,b,c,d,e,f,g+10,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 1,1;
insert into t1 select a,b,c,d,e,f,g+100,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 1,2;
insert into t1 select a,b,c,d,e,f,g+1000,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 1,4;

create table if not exists t2 as select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 1,1;
desc t2;
create table if not exists t2 as select a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q from t1 where a is not null using index idx_t1_all keylimit 1,1;


desc t2;

drop class if exists t1,t2;

