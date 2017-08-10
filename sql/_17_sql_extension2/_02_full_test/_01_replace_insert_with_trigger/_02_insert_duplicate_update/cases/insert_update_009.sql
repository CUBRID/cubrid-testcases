--nested trigger.
--trigger: 1) before update  2) after update
--trigger action: fired by insert statements executed in another trigger 


CREATE TABLE with_trigger(a int primary key, b varchar(20), c int);
INSERT INTO with_trigger VALUES (1, 'AAA', 11), (2, 'BBB', 22), (3, 'CCC', 33);
SELECT a, b, c FROM with_trigger order by 1;

CREATE TABLE trigger_actions1(id int auto_increment, a smallint primary key, b string, c numeric);
INSERT INTO trigger_actions1(a,b,c) VALUES (11, 'BEFORE UPDATE', 11);
CREATE TABLE trigger_actions2(id int auto_increment, a bigint, b varchar(20), c monetary unique);
INSERT INTO trigger_actions2(a,b,c) VALUES (22, 'AFTER UPDATE', 22);

CREATE TABLE trigger_actions3(id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
	INSERT INTO trigger_actions1 (a, b, c) VALUES (11, 'BEFORE UPDATE', 11) ON DUPLICATE KEY UPDATE b='DUPLICATED', c=c+50;
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE
	INSERT INTO trigger_actions2 (a, b, c) VALUES (22, 'AFTER UPDATE', 22) ON DUPLICATE KEY UPDATE b='DUPLICATED', c=c+50;

--NESTED TRIGGERS
CREATE TRIGGER trig_bef_upd2 BEFORE UPDATE ON trigger_actions1 EXECUTE
	INSERT INTO trigger_actions3 (a, b) VALUES (11, 'BEFORE UPDATE');
CREATE TRIGGER trig_aft_upd2 AFTER UPDATE ON trigger_actions1 EXECUTE
	INSERT INTO trigger_actions3 (a, b) VALUES (22, 'AFTER UPDATE');


INSERT INTO with_trigger VALUES (3, 'DDD', 44) ON DUPLICATE KEY UPDATE b='DUPLICATE', c=44;
SELECT *FROM with_trigger order by 1;
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;
SELECT * FROM trigger_actions3 order by 1;

--REPLACE INTO with_trigger VALUES (4, 'FFF', 55);
--SELECT * FROM with_trigger order by 1;
--SELECT * FROM trigger_actions1;
--SELECT * FROM trigger_actions2;
--SELECT * FROM trigger_actions3;


DROP TRIGGER trig_bef_upd;
DROP TRIGGER trig_aft_upd;

DROP TRIGGER trig_bef_upd2;
DROP TRIGGER trig_aft_upd2;

DROP TABLE with_trigger;
DROP TABLE trigger_actions1;
DROP TABLE trigger_actions2;
DROP TABLE trigger_actions3;
