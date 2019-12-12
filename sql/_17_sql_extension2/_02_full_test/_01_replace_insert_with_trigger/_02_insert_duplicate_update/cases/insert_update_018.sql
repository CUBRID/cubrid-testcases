--insert loop
--trigger: 1) before updete 
--trigger action: insert into the table with trigger



CREATE TABLE with_trigger(a int, b char(20) unique, c smallint);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by a;

CREATE TABLE with_trigger2(a int, b char(20) unique, c smallint);
INSERT INTO with_trigger2 VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger2 order by a;

CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
	INSERT INTO with_trigger2 VALUES (4, 'BBB', 4) ON DUPLICATE KEY UPDATE b='DUPLICATED';
CREATE TRIGGER trig_bef_upd2 BEFORE UPDATE ON with_trigger2 EXECUTE
	INSERT INTO with_trigger VALUES (4, 'BBB', 4) ON DUPLICATE KEY UPDATE b='DUPLICATED';

INSERT INTO with_trigger VALUES (4, 'BBB', 4) ON DUPLICATE KEY UPDATE b='DUPLICATED';
SELECT * FROM with_trigger order by a;
SELECT * FROM with_trigger2 order by a;

DROP TRIGGER trig_bef_upd;
DROP TRIGGER trig_bef_upd2;

DROP TABLE with_trigger;
DROP TABLE with_trigger2;
