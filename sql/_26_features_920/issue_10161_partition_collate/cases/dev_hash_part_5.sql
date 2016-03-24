--+ holdcas on;

drop table if exists t1;
SET NAMES iso88591 COLLATE iso88591_bin; 
CREATE TABLE t1 (i int, code VARCHAR(10)) collate iso88591_bin PARTITION BY HASH (code) PARTITIONS 5;
insert into t1(i, code) values (1, 'BE');
insert into t1(i, code) values (2, 'Be');
insert into t1(i, code) values (3, 'b');
insert into t1(i, code) values (4, 'B');
insert into t1(i, code) values (5, 'b ');

-- \t
insert into t1(i, code) values (6, 'b' + chr(9));	
-- \r
insert into t1(i, code) values (7, 'b' + chr(13)); 	
-- \n
insert into t1(i, code) values (8, 'b' + chr(10)); 	

select i, code from t1 order by i;


select distinct code from t1;


select * from t1 where code='b' order by i;


select * from t1 where code='be' order by i;


select * from t1 where code like 'b%' order by i;

select * from t1__p__p0 order by i;
select * from t1__p__p1 order by i;
select * from t1__p__p2 order by i;
select * from t1__p__p3 order by i;

drop table t1;

SET NAMES iso88591;
commit;
--+ holdcas off;
