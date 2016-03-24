--+ holdcas on;

drop table if exists t1;
SET NAMES utf8 COLLATE utf8_de_exp_ai_ci; 
CREATE TABLE t1 (i int, code VARCHAR(10)) collate utf8_de_exp_ai_ci PARTITION BY HASH (code) PARTITIONS 4;
insert into t1(i, code) values (1, 'AE');
insert into t1(i, code) values (2, 'ae');
insert into t1(i, code) values (3, 'Ä');
insert into t1(i, code) values (4, 'ä');

-- all 4 rows. 
select i, code from t1 order by i;

--only one row
select distinct code from t1;

--all 4 rows
select * from t1 where code='ä' order by i;

--all 4 rows
select * from t1 where code='ae' order by i;

-- all 4 rows (no prunning)
select * from t1 where code like 'ae%' order by i;

select * from t1__p__p0 order by i;
select * from t1__p__p1 order by i;
select * from t1__p__p2 order by i;
select * from t1__p__p3 order by i;


drop table t1;

SET NAMES iso88591;
commit;
--+ holdcas off;

