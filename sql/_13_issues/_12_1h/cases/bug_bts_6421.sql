--TEST: when update multiple tables, affected rows seem not correct.

CREATE  TABLE  t1 (a int not null primary key, b int not null, key  i_t1_b (b));
CREATE  TABLE  t2 (a int not null primary key, b int not null, key  i_t2_b (b));

INSERT  INTO t1  VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12);
INSERT  INTO t2  VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9);

--query result show 108 rows affected. This is not same with mysql.  12 rows were affected will be good.
UPDATE t1, t2 SET t1.a=t1.a + 100;

update t1, t2 set t1.a=t2.b where t1.b=t2.b;


drop table t1, t2;




