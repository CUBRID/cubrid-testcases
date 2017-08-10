--test about DEFAULT value.


CREATE TABLE with_trigger(a int primary key, b char(10), c int default 10);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by a;

CREATE TABLE trigger_actions(a int auto_increment, b int, c char(20));

CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (1, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (2, 'AFTER INSERT');

REPLACE INTO with_trigger values (4, 'DDD', 22);
SELECT * FROM trigger_actions order by a;
SELECT * FROM with_trigger order by a;

REPLACE INTO with_trigger set a=4, b='FFF';
SELECT * FROM trigger_actions order by a;
SELECT * FROM with_trigger order by a;

DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
