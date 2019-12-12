--1.replace into a table with partition
--trigger: 1) before delete  2) after delete 
--trigger action: insert/update/delete into 1 table.


CREATE TABLE with_trigger(a int, b char(20), c short, primary key(b, a))
PARTITION BY RANGE(a)
(PARTITION lt_10 VALUES LESS THAN (10),
PARTITION lt_20 VALUES LESS THAN (20) );

INSERT INTO with_trigger VALUES (5, 'AAA', 1), (2, 'BBB', 2), (14, 'CCC', 3);
SELECT * FROM with_trigger__p__lt_10 order by a;
SELECT * FROM with_trigger__p__lt_20 order by a;

CREATE TABLE trigger_actions(a int auto_increment, b int, c char(20));

CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (1, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_del AFTER DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions (b, c) VALUES (2, 'AFTER INSERT');

REPLACE INTO with_trigger VALUES (2, 'BBB', 4);
SELECT * FROM trigger_actions order by a;
SELECT * FROM with_trigger order by a;

DROP TRIGGER trig_bef_del;
DROP TRIGGER trig_aft_del;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
