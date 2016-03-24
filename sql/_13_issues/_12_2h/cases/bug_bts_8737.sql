CREATE TABLE t1 ( a varchar(10) charset utf8 collate utf8_en_ci, index i_a(a) where a||''='A');
drop table t1;