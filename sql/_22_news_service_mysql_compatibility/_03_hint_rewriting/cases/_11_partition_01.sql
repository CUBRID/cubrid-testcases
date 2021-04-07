--+ holdcas on;

CREATE TABLE participant2 (host_year INT, nation CHAR(3), gold INT, silver INT, bronze INT)
PARTITION BY RANGE (host_year)
(PARTITION before_2000 VALUES LESS THAN (2000),
PARTITION before_2008 VALUES LESS THAN (2008) );
 
INSERT INTO participant2 VALUES (1988, 'NZL', 3, 2, 8);
INSERT INTO participant2 VALUES (1988, 'CAN', 3, 2, 5);
INSERT INTO participant2 VALUES (1996, 'KOR', 7, 15, 5);
INSERT INTO participant2 VALUES (2000, 'RUS', 32, 28, 28);
INSERT INTO participant2 VALUES (2004, 'JPN', 16, 9, 12);

create index i1 on participant2(host_year);

create table t(a int);

--test
select /*+ recompile */ * from participant2 use index (i1) where host_year>1900;

--test
select /*+ recompile */ * from participant2 force index (i1) where host_year>1900;

--test
select /*+ recompile */ count(*) from participant2 ignore index (i1) where host_year>1900;

--test
select /*+ recompile */ * from participant2 use index (i1) where host_year>1900 using index i1;

--test
select /*+ recompile */ * from participant2 force index (i1) where host_year>1900 using index i1;

--test
select /*+ recompile */ count(*) from participant2 ignore index (i1) where host_year>1900 using index i1;


--test
select /*+ recompile */ * from participant2 use index (i1) where host_year>1900 using index none;

--test
select /*+ recompile */ * from participant2 force index (i1) where host_year>1900 using index none;

--test
select /*+ recompile */ count(*) from participant2 ignore index (i1) where host_year>1900 using index none;

--test
select /*+ recompile */ * from participant2 use index (i1) where host_year>1900 using index all except i1;

--test
select /*+ recompile */ * from participant2 force index (i1) where host_year>1900 using index all except i1;

--test
select /*+ recompile */ count(*) from participant2 ignore index (i1) where host_year>1900 using index all except i1;

--test
select /*+ recompile */ count(*) from participant2 ignore index (i1) left join t on host_year=t.a where host_year>1900 using index all except i1;

drop table participant2;
drop table t;

commit;
--+ holdcas off;
