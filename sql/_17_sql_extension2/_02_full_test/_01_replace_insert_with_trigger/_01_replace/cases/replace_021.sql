--replace loop
--trigger: 1) before delete 
--trigger action: replace into the table with trigger



CREATE TABLE with_trigger(a int, b char(20) unique, c short);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by a;

CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
	REPLACE INTO with_trigger VALUES (4, 'BBB', 4);

REPLACE INTO with_trigger VALUES (4, 'BBB', 4);
SELECT * FROM with_trigger order by a;

DROP TRIGGER trig_bef_del;

DROP TABLE with_trigger;
