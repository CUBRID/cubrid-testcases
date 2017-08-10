--replace into a table with no primary key or unique index.
--trigger: 1) before insert  2) after insert 3) before statement insert 4) after statement insert
--trigger action: insert

CREATE TABLE with_trigger(a int, b char(10), c int);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by a;

CREATE TABLE trigger_actions(a int auto_increment, b int, c char(20));

CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (1, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (2, 'AFTER INSERT');
CREATE TRIGGER trig_bef_st_ins BEFORE STATEMENT INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (3, 'BEFORE ST INSERT');
CREATE TRIGGER trig_aft_st_ins AFTER STATEMENT INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (4, 'AFTER ST INSERT');

REPLACE INTO with_trigger VALUES (4, 'DDD', 4);
SELECT * FROM trigger_actions order by a;
SELECT * FROM with_trigger order by a;

REPLACE INTO with_trigger VALUES (4, 'FFF', 4);
SELECT * FROM trigger_actions order by a;
SELECT * FROM with_trigger order by a;

DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;
DROP TRIGGER trig_bef_st_ins;
DROP TRIGGER trig_aft_st_ins;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
