--1.insert into an inherited table
--trigger: 1) before delete  2) after delete 
--trigger action: insert/update/delete into 1 table.

drop table if exists with_trigger,with_trigger2,trigger_actions;
CREATE TABLE with_trigger(a int, b char(20) unique);
INSERT INTO with_trigger VALUES (1, 'AAA'), (2, 'BBB'), (3, 'CCC');

--subclass
CREATE TABLE with_trigger2 under with_trigger(c short, d bit(10) unique);
INSERT INTO with_trigger2 VALUES (4, 'EEE', 1, B'1010100'), (5, 'FFF', 2, B'1100111');
SELECT * FROM with_trigger2 order by 1;

CREATE TABLE trigger_actions(a int auto_increment, b int, c char(20));

--triggers on super class
CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (1, 'BEFORE DELETE');
CREATE TRIGGER trig_aft_del AFTER DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (2, 'AFTER INSERT');

--triggers on sub class
CREATE TRIGGER trig_bef_del1 BEFORE DELETE ON with_trigger2 EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (3, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_del1 AFTER DELETE ON with_trigger2 EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (4, 'AFTER INSERT');

--error, replace into super class
INSERT INTO with_trigger VALUES (8, 'BBB') ON DUPLICATE KEY UPDATE b='DUPLICATED';
--error, replace into sub class
INSERT INTO with_trigger2 VALUES (4, 'ccc', 3, B'1010100') ON DUPLICATE KEY UPDATE c=1111;

DROP TRIGGER trig_bef_del;
DROP TRIGGER trig_aft_del;
DROP TRIGGER trig_bef_del1;
DROP TRIGGER trig_aft_del1;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
DROP TABLE with_trigger2;
