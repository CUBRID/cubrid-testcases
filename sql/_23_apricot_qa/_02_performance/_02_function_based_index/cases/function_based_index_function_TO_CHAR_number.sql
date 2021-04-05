--+ holdcas on;
create table t1(a char(1200),   b varchar(1200),  c nchar(1200),  d NCHAR VARYING(1200),  e BIT(1200),  f BIT VARYING(1200),  g int,  h SMALLINT,  i BIGINT,  j NUMERIC,  k FLOAT,  l DOUBLE,  m MONETARY,  n DATE,  o TIME,  p TIMESTAMP,  q DATETIME);

insert into t1 values (
  '123456',
  '2009',
  N'2009',
  N'1999',
  B'1111111111',
  B'1111111111',
  12345,
  255,
  9223372036854775807,
  0,
  123.4567,
  1.234567,
  -24,
  DATE '1999-01-01',
  TIME '22:23:00',
  TIMESTAMP '2010-02-04 16:50:11',
  DATETIME  '2010-02-04 16:50:11');
insert into t1 values (null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);

create index i_t1_a2q on t1(to_char(a,'99'));
create index i_t1_a2p on t1(to_char(b, '99.999EEEE'));
create index i_t1_a2o on t1(to_char(c,'C9,999,999,999'));
create index i_t1_a2n on t1(to_char(d, '99999.999'));
create index i_t1_a2m on t1(to_char(e,'99'));
create index i_t1_a2l on t1(to_char(f,'99'));
create index i_t1_a2k on t1(to_char(g,'S999999'));
select /*+ RECOMPILE */* from t1 where to_char(g,'S999999')) =' +12345' ;
create index i_t1_a2j on t1(to_char(h,'S0999'));
select /*+ RECOMPILE */* from t1 where to_char(h,'S0999','en_US')) ='+0255' ;
select /*+ RECOMPILE */* from t1 where to_char(h,'S0999') ='+0255' ;
create index i_t1_a2i on t1(to_char(i,'C9,999,999,999,999,999,999'));
select /*+ RECOMPILE */* from t1 where to_char(i,'C9,999,999,999,999,999,999')) ='$9,223,372,036,854,775,807' ;
create index i_t1_a2h on t1(to_char(j,'C99','en_US'));
select /*+ RECOMPILE */* from t1 where to_char(i,'C99')) =' $0' ;
select /*+ RECOMPILE */* from t1 where to_char(i,'C99','en_US')) =' $0' ;
create index i_t1_a2g on t1(to_char(k,'999.99999'));
select /*+ RECOMPILE */* from t1 where to_char(k,'999.99999')) ='123.45670' ;
create index i_t1_a2f on t1(to_char(l,'99.999EEEE', 'en_US'));
select /*+ RECOMPILE */* from t1 where to_char(l,'99.999EEEE', 'en_US')) ='1.235E+00' ;
create index i_t1_a2e on t1(to_char(m,'99'));
create index i_t1_a2d on t1(to_char(n,'99'));
create index i_t1_a2c on t1(to_char(o,'99'));
create index i_t1_a2b on t1(to_char(p,'99'));
create index i_t1_a2a on t1(to_char(q,'99'));
drop table t1;
commit;
--+ holdcas off;
