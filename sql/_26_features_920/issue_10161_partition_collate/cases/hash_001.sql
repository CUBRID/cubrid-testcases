
CREATE TABLE t2 ( code VARCHAR(10)) collate utf8_en_ci PARTITION BY HASH (code) PARTITIONS 4; 
INSERT INTO t2(code) VALUES ('A'); 
INSERT INTO t2(code) VALUES ('a'); 
INSERT INTO t2(code) VALUES ('AA'); 
INSERT INTO t2(code) VALUES ('aa'); 

select * from t2 order by 1;

drop table t2;


