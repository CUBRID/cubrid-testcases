--insert into a table with a primary key
--trigger: 1) before delete  2) after delete  3) before insert  4) after insert
--trigger action: insert/delete/update the same table which data was replaced into.


CREATE TABLE with_trigger(a int primary key, b char(20), c double);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by 1;

CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
	INSERT INTO with_trigger VALUES (11, 'BEFORE UPDATE', 11);
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE
	UPDATE with_trigger SET b='AFTER UPDATE' WHERE a=11;

--Error: PK constraint violation
INSERT INTO with_trigger VALUES (2, 'DDD', 7) ON DUPLICATE KEY UPDATE c=c+1;
SELECT * FROM with_trigger order by 1;

--REPLACE INTO with_trigger VALUES (4, 'FFF', 4);
--SELECT * FROM with_trigger;

--REPLACE INTO with_trigger VALUES (4, 'GGG', 5);
--SELECT * FROM with_trigger;

DROP TRIGGER trig_bef_upd;
DROP TRIGGER trig_aft_upd;

DROP TABLE with_trigger;
