--+ holdcas on;

drop table if exists t1;
SET NAMES iso88591 COLLATE iso88591_en_cs; 
CREATE TABLE t1 (i int, code VARCHAR(10)) collate iso88591_en_cs PARTITION BY HASH (code) PARTITIONS 4;
insert into t1(i, code) values (1, 'AE');
insert into t1(i, code) values (2, 'ae');
insert into t1(i, code) values (3, 'a');
insert into t1(i, code) values (4, 'A');


select i, code from t1 order by i;


select distinct code from t1;


select * from t1 where code='a'  order by i;


select * from t1 where code='ae'  order by i;


select * from t1 where code like 'a%'  order by i;

select * from t1__p__p0  order by i;
select * from t1__p__p1  order by i;
select * from t1__p__p2  order by i;
select * from t1__p__p3  order by i;

drop table t1;

SET NAMES iso88591;
commit;
--+ holdcas off;