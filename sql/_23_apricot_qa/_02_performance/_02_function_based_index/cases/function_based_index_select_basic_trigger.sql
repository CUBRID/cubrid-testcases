--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1(  a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int primary key,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

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
  100,
  -100,
  DATE '2008-10-31',
  TIME '00:00:00',
  TIMESTAMP '2010-10-31 01:15:45',
  DATETIME  '2008-10-31 13:15:45');
insert into t1 values (null,null,null,null,null,null,11,null,null,null,null,null,null,null,null,null,null);


create index i_t1_gh on t1(log10(l));


create table t2 like t1;
insert into t2 select * from t1;

create trigger tri_update_t2
before update on t1 
execute replace t2 values ('update','1234567890',N'abc',N'ABC', B'1111111111', B'1111111111',11,255,9223372036854775806,0,0,10,-200,DATE '2008-10-31',TIME '00:00:00',TIMESTAMP '2010-10-31 01:15:45',DATETIME  '2008-10-31 13:15:45');

create trigger tri_insert_t2
before update on t1 
execute insert t2 values ('insert','1234567890',N'abc',N'ABC', B'1111111111', B'1111111111',12,255,9223372036854775806,0,0,1,-200,DATE '2008-10-31',TIME '00:00:00',TIMESTAMP '2010-10-31 01:15:45',DATETIME  '2008-10-31 13:15:45');

update t1 set a='0' where g=11;

--TEST:
select /*+ recompile */ * from t2 where log10(l)>=0 order by 1 ;

drop trigger tri_update_t2;
drop trigger tri_insert_t2;
drop table t1;
drop table t2;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
