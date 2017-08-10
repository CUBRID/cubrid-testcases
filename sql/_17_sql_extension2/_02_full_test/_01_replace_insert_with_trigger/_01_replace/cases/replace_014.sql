--replace into a table with a composite primary key.
--trigger: 1) before insert  2) after insert  3) before delete  4) after delete
--trigger action: insert into 1 table.


CREATE TABLE with_trigger(a int, b char(10), c int, primary key(a, b));
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by 1;

CREATE TABLE trigger_actions(id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions(a, b) VALUES (1, 'BEFORE DELETE');
CREATE TRIGGER trig_aft_del AFTER DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions(a, b) VALUES (2, 'AFTER DELETE');
CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions(a, b) VALUES (3, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions(a, b) VALUES (4, 'AFTER INSERT');

REPLACE INTO with_trigger VALUES (3, 'DDD', 4);
SELECT * FROM trigger_actions order by 1;
SELECT * FROM with_trigger order by 1;

REPLACE INTO with_trigger VALUES (3, 'CCC', 5);
SELECT * FROM trigger_actions order by 1;
SELECT * FROM with_trigger order by 1;

REPLACE INTO with_trigger VALUES (2, 'BBB', 6);
SELECT * FROM trigger_actions order by 1;
SELECT * FROM with_trigger order by 1;

DROP TRIGGER trig_bef_del;
DROP TRIGGER trig_aft_del;
DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
