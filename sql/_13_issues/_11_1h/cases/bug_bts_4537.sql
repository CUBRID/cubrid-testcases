CREATE TABLE t1 (a1 int auto_increment primary key, i1 int);
CREATE TABLE t2 (a2 int auto_increment primary key, i2 int);

CREATE TRIGGER trig_bef_ins_t1 BEFORE INSERT ON t1 EXECUTE 
INSERT INTO t2(i2) VALUES (-1);

CREATE TRIGGER trig_bef_ins_t2 BEFORE INSERT ON t2 EXECUTE
INSERT INTO t1(i1) VALUES (-10);

CREATE TRIGGER trig_bef_ins_t2_s BEFORE STATEMENT INSERT ON t2 EXECUTE
INSERT INTO t1(i1) VALUES (-100); 

INSERT INTO t2(i2) VALUES(1);


DROP TRIGGER trig_bef_ins_t1, trig_bef_ins_t2, trig_bef_ins_t2_s;
DROP TABLE t1, t2;



CREATE TABLE with_trigger(a int, b string, c smallint);

CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO with_trigger(a, b, c) VALUES (33, 'BEFORE INSERT', 33);

INSERT INTO with_trigger(a, b, c) VALUES (66, 'AFTER UPDATE', 66);


drop table with_trigger;


