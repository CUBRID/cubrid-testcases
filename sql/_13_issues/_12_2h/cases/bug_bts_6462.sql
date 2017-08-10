drop table if exists t1,t2;
CREATE TABLE t1 ( id int auto_increment NOT NULL, field_1 int NOT NULL, field_2 varchar(255) , field_3 varchar(255), PRIMARY KEY (id), UNIQUE KEY field_1 (field_1, field_2) );

CREATE TABLE t2 (field_a int (10) NOT NULL, field_b varchar (255) NOT NULL, field_c varchar (255) NOT NULL);

INSERT INTO t1 (field_1, field_2, field_3) VALUES (1, 'a', 't1-a');
INSERT INTO t1 (field_1, field_2, field_3) VALUES (2, 'b', 't1-b');
INSERT INTO t1 (field_1, field_2, field_3) VALUES (3, 'c', 't1-c');

INSERT INTO t2 (field_a, field_b, field_c) VALUES (1, 'a', 't2-a');
INSERT INTO t2 (field_a, field_b, field_c) VALUES (2, 'b', 't2-b');
INSERT INTO t2 (field_a, field_b, field_c) VALUES (3, 'c', 't2-c');

--to verify whether or not support below statement. Actually, CUBRID could not recognize table t2. But MySQL is good.
INSERT INTO t1 (field_1, field_2, field_3) SELECT t2.field_a, t2.field_b, t2.field_c FROM t2 ON DUPLICATE KEY UPDATE t1.field_3=t2.field_c;

select * from t1 order by id;

drop table if exists t1,t2;    
