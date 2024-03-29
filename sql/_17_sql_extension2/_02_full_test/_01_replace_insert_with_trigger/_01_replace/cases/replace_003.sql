--replace into a table with a unique index.
--trigger: 1) before insert  2) after insert
--trigger actions on 2 tables.


CREATE TABLE with_trigger(a int, b char(10), c int unique);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by 1;

CREATE TABLE trigger_actions1(id int auto_increment, a int, b char(20));
CREATE TABLE trigger_actions2(id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (1, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions2(a, b) VALUES (2, 'AFTER INSERT');

REPLACE INTO with_trigger VALUES (4, 'DDD', 4);
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;
SELECT * FROM with_trigger order by 1;

REPLACE INTO with_trigger VALUES (4, 'FFF', 4);
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;
SELECT * FROM with_trigger order by 1;

DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;

DROP TABLE trigger_actions1;
DROP TABLE trigger_actions2;
DROP TABLE with_trigger;
