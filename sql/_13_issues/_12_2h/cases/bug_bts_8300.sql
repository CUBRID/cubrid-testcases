CREATE TABLE participant2 ( host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT)
PARTITION BY RANGE (host_year)
( PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );
create index idx on participant2(log10(gold));
drop index idx on participant2__p__before_2008; 
select /*+ recompile */ * from participant2  where log10(gold)>0;
drop table participant2;
CREATE TABLE t (i INT) PARTITION BY HASH(i) PARTITIONS 4; 
ALTER TABLE t ADD SUPERCLASS u;
drop table t;
