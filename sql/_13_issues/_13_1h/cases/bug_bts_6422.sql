drop table if exists t1;
drop table if exists t2;

CREATE  TABLE  t1 (a int not null primary key, b int not null, key i_t1_b (b));
CREATE  TABLE  t2 (a int not null primary key, b int not null, key i_t1_b  (b));

INSERT  INTO t1  VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12);

INSERT  INTO t2  VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9);

--below sql will throw "ERROR: Semantic: System error (generate attr) in ../../src/parser/xasl_generation.c (line: 9208) "
UPDATE t1, t2 SET t1.b=t1.b + 2 , t2.b=t1.b + 10 WHERE t1.b BETWEEN 3 AND 5 AND t1.a = t2.a + 100;

UPDATE t1, t2 SET t1.b=t2.b + 2 , t2.b=t1.b + 10 WHERE t1.b BETWEEN 3 AND 5 AND t1.a = t2.a + 100;

UPDATE t1,t2 SET t1.b=t2.b/t1.b , t2.b=t1.b/t2.b WHERE t1.b >0 and t1.b< 1000 AND t1.a = t2.a + 100;

UPDATE t1,t2 SET t1.b=t2.b/t1.b , t2.b=t1.b/t2.b WHERE t1.b != t1.b  AND t1.a = t2.a + 100;

UPDATE t1,t2 SET t1.b=t2.b/t1.b  WHERE t1.b = t1.b  AND t1.a = t2.a + 100;

drop table t1;
drop table t2;

CREATE  TABLE  t1 (a int not null, b int not null, key i_t1_b (b), primary key(a,b)) partition by hash(b) partitions 2;
CREATE  TABLE  t2 (a int not null, b int not null, key i_t1_b  (b), primary key(a,b))  partition by hash(b) partitions 2;

INSERT  INTO t1  VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10), (11, 11), (12, 12);

INSERT  INTO t2  VALUES (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9);

--below sql will throw "ERROR: Semantic: System error (generate attr) in ../../src/parser/xasl_generation.c (line: 9208) "
UPDATE t1, t2 SET t1.b=t1.b + 2 , t2.b=t1.b + 10 WHERE t1.b BETWEEN 3 AND 5 AND t1.a = t2.a + 100;

UPDATE t1, t2 SET t1.b=t2.b + 2 , t2.b=t1.b + 10 WHERE t1.b BETWEEN 3 AND 5 AND t1.a = t2.a + 100;

UPDATE t1, t2 SET t1.b=t2.b + 2 , t2.b=t1.b + 10 WHERE t1.b BETWEEN 3 AND 5 AND t1.a = t2.a + 100;

UPDATE t1,t2 SET t1.b=t2.b/t1.b , t2.b=t1.b/t2.b WHERE t1.b != t1.b  AND t1.a = t2.a + 100;

UPDATE t1,t2 SET t1.b=t2.b/t1.b  WHERE t1.b = t1.b  AND t1.a = t2.a + 100;

drop table t1;
drop table t2;





