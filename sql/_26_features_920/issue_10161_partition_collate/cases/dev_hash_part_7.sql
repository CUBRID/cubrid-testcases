--+ holdcas on;

drop table if exists t1;
SET NAMES euckr COLLATE euckr_bin; 
CREATE TABLE t1 (i int, code VARCHAR(10)) collate euckr_bin PARTITION BY HASH (code) PARTITIONS 4;
insert into t1(i, code) values (1, 'a b');
-- 41377 = EUC encoding for A1A1 (double byte padding character)
insert into t1(i, code) values (2, concat ('a', chr (41377 using euckr), 'b'));
insert into t1(i, code) values (3, 'a ');
insert into t1(i, code) values (4, concat ('a', chr (41377 using euckr)));
insert into t1(i, code) values (5, concat ('a ', chr (41377 using euckr)));
insert into t1(i, code) values (6, concat ('a', chr (41377 using euckr),' '));


select i, code from t1 order by i;


select distinct code from t1;


select i, code, hex(code) from t1 where code='a'  order by i;


select i, code, hex(code) from t1 where code='a b'  order by i;


select i, code, hex(code) from t1 where code like 'a%'  order by i;

select i, code, hex(code) from t1__p__p0 order by i;
select i, code, hex(code) from t1__p__p1 order by i;
select i, code, hex(code) from t1__p__p2 order by i;
select i, code, hex(code) from t1__p__p3 order by i;

drop table t1;

SET NAMES iso88591;
commit;
--+ holdcas off;
