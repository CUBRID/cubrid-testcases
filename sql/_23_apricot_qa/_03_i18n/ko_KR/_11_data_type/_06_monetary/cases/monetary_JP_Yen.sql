CREATE TABLE t1 (m1 monetary);
INSERT INTO t1 VALUES (бя4.00);
INSERT INTO t1 VALUES (бя-1);
INSERT INTO t1 VALUES (\JPY 1);
INSERT INTO t1 VALUES (\JPY -2);
INSERT INTO t1 VALUES (\JPY 1.1);
INSERT INTO t1 VALUES (\JPY -2.2);
INSERT INTO t1 VALUES (\JPY 123456789012345678901234567890123456789012345678901234567890);
select * from t1 order by m1;
select m1,cast(m1 as string) from t1 order by 2;

drop table t1;
CREATE TABLE t (m1 monetary default \JPY1, m1_1 monetary default \JPY-1, m100 monetary default $100, m100_1 monetary default $-100)
insert into t(m1)values(\JPY 10);
insert into t(m1_1)values(\JPY 10);
insert into t(m100)values(\JPY 10);
insert into t(m100_1)values(\JPY 123456789012345678901234567890123456789012345678901234567890);
select * from t order by m1;
drop table t;