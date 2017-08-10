--nested trigger.
--trigger: 1) before delete  2) after delete  3) before insert  4) after insert 5) before update  6) after update
--trigger action: insert/delete/update multiple tables.


CREATE TABLE with_trigger(a int primary key, b varchar(20), c int);
INSERT INTO with_trigger VALUES (1, 'AAA', 11), (2, 'BBB', 22), (3, 'CCC', 33);
SELECT a, b, c FROM with_trigger order by 1;

CREATE TABLE trigger_actions1(id int auto_increment, a smallint primary key, b string, c numeric);
CREATE TABLE trigger_actions2(id int auto_increment, a bigint, b varchar(20), c monetary unique);

CREATE TABLE trigger_actions3(id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions1 (a, b, c) VALUES (11, 'BEFORE DELETE', 11);
CREATE TRIGGER trig_aft_del AFTER DELETE ON with_trigger EXECUTE
	REPLACE INTO trigger_actions1 (a, b, c) VALUES (11, 'AFTER DELETE', 22);
CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions2 (a, b, c) VALUES (33, 'BEFORE INSERT', 33);
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	REPLACE INTO trigger_actions2 (a, b, c) VALUES (44, 'AFTER INSERT', 33);

--NESTED TRIGGERS
CREATE TRIGGER trig_bef_del2 BEFORE DELETE ON trigger_actions1 EXECUTE
	INSERT INTO trigger_actions3 (a, b) VALUES (11, 'BEFORE DELETE');
CREATE TRIGGER trig_aft_del2 AFTER DELETE ON trigger_actions1 EXECUTE
	INSERT INTO trigger_actions3 (a, b) VALUES (22, 'AFTER DELETE');
CREATE TRIGGER trig_bef_ins2 BEFORE INSERT ON trigger_actions2 EXECUTE
	INSERT INTO trigger_actions3 (a, b) VALUES (33, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins2 AFTER INSERT ON trigger_actions2 EXECUTE
	INSERT INTO trigger_actions3 (a, b) VALUES (44, 'AFTER INSERT');


REPLACE INTO with_trigger VALUES (3, 'DDD', 44);
SELECT *FROM with_trigger order by 1;
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;
SELECT * FROM trigger_actions3 order by 1;

--error, unique violation
REPLACE INTO with_trigger VALUES (4, 'FFF', 55);
--SELECT * FROM with_trigger;
--SELECT * FROM trigger_actions1;
--SELECT * FROM trigger_actions2;
--SELECT * FROM trigger_actions3;


DROP TRIGGER trig_bef_del;
DROP TRIGGER trig_aft_del;
DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;

DROP TRIGGER trig_bef_del2;
DROP TRIGGER trig_aft_del2;
DROP TRIGGER trig_bef_ins2;
DROP TRIGGER trig_aft_ins2;

DROP TABLE with_trigger;
DROP TABLE trigger_actions1;
DROP TABLE trigger_actions2;
DROP TABLE trigger_actions3;
