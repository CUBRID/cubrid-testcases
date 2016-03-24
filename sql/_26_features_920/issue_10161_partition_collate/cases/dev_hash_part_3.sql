--+ holdcas on;

drop table if exists t1;
SET NAMES iso88591 COLLATE iso88591_en_ci; 
CREATE TABLE t1 (i int, code VARCHAR(10)) collate iso88591_en_ci PARTITION BY HASH (code) PARTITIONS 4;
insert into t1(i, code) values (1, 'AE');
insert into t1(i, code) values (2, 'ae');
insert into t1(i, code) values (3, 'a');
insert into t1(i, code) values (4, 'A');


select i, code from t1 order by i;

-- 2 rows 
select distinct code from t1;

-- expect 2 rows ( A and a)
select * from t1 where code='a' order by i;

-- expect 2 rows ( AE and ae)
select * from t1 where code='ae' order by i;

-- expect all 4 rows
select * from t1 where code like 'a%' order by i;

select * from t1__p__p0 order by i;
select * from t1__p__p1 order by i;
select * from t1__p__p2 order by i;
select * from t1__p__p3 order by i;


drop table t1;

SET NAMES iso88591;
commit;
--+ holdcas off;
