Drop table if exists t1;
CREATE TABLE t1 (m1 string);
INSERT INTO t1 VALUES ('$1');
INSERT INTO t1 VALUES ('\TL3');
INSERT INTO t1 VALUES ('\JPY4');
INSERT INTO t1 VALUES ('\KRW5');
INSERT INTO t1 VALUES ('\GBP6');

select * from t1 order by 1;
alter table t1 change m1 m1 monetary;
--we expect the converting is successful
select * from t1 order by 1;
drop table t1;



CREATE TABLE t1 (m1 string charset binary);
INSERT INTO t1 VALUES ('$1');
INSERT INTO t1 VALUES ('TL3');
INSERT INTO t1 VALUES ('¥4');
INSERT INTO t1 VALUES ('₩5');
INSERT INTO t1 VALUES ('£6');

select * from t1 order by 1;
alter table t1 change m1 m1 monetary;
--we expect the converting is successful
select * from t1 order by 1;
drop table t1;











