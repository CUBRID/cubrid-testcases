--replace loop
--trigger: 1) before delete 
--trigger action: replace into the table with trigger



CREATE TABLE with_trigger(a int, b char(20) unique, c smallint);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger;

CREATE TABLE with_trigger2(a int, b char(20) unique, c smallint);
INSERT INTO with_trigger2 VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger2;

CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
	REPLACE INTO with_trigger2 VALUES (4, 'BBB', 4);
CREATE TRIGGER trig_bef_del2 BEFORE DELETE ON with_trigger2 EXECUTE
	REPLACE INTO with_trigger VALUES (4, 'BBB', 4);

REPLACE INTO with_trigger VALUES (4, 'BBB', 4);
SELECT * FROM with_trigger order by a;
SELECT * FROM with_trigger2 order by a;

DROP TRIGGER trig_bef_del;
DROP TRIGGER trig_bef_del2;

DROP TABLE with_trigger;
DROP TABLE with_trigger2;
