--trigger: 1) before delete  2) after delete  3) before insert  4) after insert
--trigger action: insert/delete/update the same table which data was replaced into.

CREATE TABLE with_trigger(a int primary key, b char(20), c double unique);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by 1;

CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
	INSERT INTO with_trigger VALUES (11, 'BEFORE DELETE', 11);
CREATE TRIGGER trig_aft_del AFTER DELETE ON with_trigger EXECUTE
	UPDATE with_trigger SET B='AFTER DELETE' WHERE a=11;
CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO with_trigger VALUES (33, 'BEFORE INSERT', 33);
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	DELETE FROM with_trigger WHERE c=33;

--Error: Can't update table 'with_trigger' in stored function/trigger because it is already used by statement which invoked this stored function/trigger.
REPLACE INTO with_trigger VALUES (2, 'DDD', 6);
--SELECT * FROM with_trigger;

--REPLACE INTO with_trigger VALUES (4, 'FFF', 4);
--SELECT * FROM with_trigger;

--REPLACE INTO with_trigger VALUES (4, 'GGG', 5);
--SELECT * FROM with_trigger;

DROP TRIGGER trig_bef_del;
DROP TRIGGER trig_aft_del;
DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;

DROP TABLE with_trigger;
