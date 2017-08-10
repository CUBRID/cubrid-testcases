--1.replace into a table with a foreign key
--trigger: 1) before insert  2) after insert  3) before delete  4) after delete
--trigger action: insert/update/delete into 1 table.


CREATE TABLE with_trigger(a int primary key, b char(10), c int);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3), (4, 'DDD', 4);
SELECT * FROM with_trigger order by 1;

CREATE TABLE with_trigger2(a string unique, b int, 
			   CONSTRAINT fk_id FOREIGN KEY(b) REFERENCES with_trigger(a)
			   ON DELETE CASCADE ON UPDATE SET NULL);
INSERT INTO with_trigger2 VALUES ('AAA', 1), ('BBB', 2), ('CCC', 3);
SELECT * FROM with_trigger2 order by 1;   


--triggers of the table which is referenced
CREATE TABLE trigger_actions1(id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_del1 BEFORE DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (1, 'BEFORE DELETE');
CREATE TRIGGER trig_aft_del1 AFTER DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (2, 'AFTER DELETE');
CREATE TRIGGER trig_aft_del1_1 AFTER DELETE ON with_trigger EXECUTE
	UPDATE trigger_actions1 SET b='CHANGE_BEFORE DELETE' WHERE a=1;
CREATE TRIGGER trig_bef_ins1 BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (3, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins1 AFTER INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (4, 'AFTER INSERT');
CREATE TRIGGER trig_aft_ins1_1 AFTER INSERT ON with_trigger EXECUTE
	DELETE FROM trigger_actions1 WHERE a=3;
CREATE TRIGGER trig_aft_ins1_2 AFTER INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (3, 'NEW_BEFORE INSERT');


--triggers of the table which is referenced
CREATE TABLE trigger_actions2(id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_del2 BEFORE DELETE ON with_trigger2 EXECUTE
        INSERT INTO trigger_actions2(a, b) VALUES (1, 'BEFORE DELETE');
CREATE TRIGGER trig_aft_del2 AFTER DELETE ON with_trigger2 EXECUTE
        INSERT INTO trigger_actions2(a, b) VALUES (2, 'AFTER DELETE');
CREATE TRIGGER trig_bef_ins2 BEFORE INSERT ON with_trigger2 EXECUTE
        INSERT INTO trigger_actions2(a, b) VALUES (3, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins2 AFTER INSERT ON with_trigger2 EXECUTE
        INSERT INTO trigger_actions2(a, b) VALUES (4, 'AFTER INSERT');


--replace into a table the index of which a foreign key references
REPLACE INTO with_trigger VALUES (3, 'CCC', 5);
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;
SELECT * FROM with_trigger order by 1;
SELECT * FROM with_trigger2 order by 1;


DROP TRIGGER trig_bef_del1;
DROP TRIGGER trig_aft_del1;
DROP TRIGGER trig_aft_del1_1;
DROP TRIGGER trig_bef_ins1;
DROP TRIGGER trig_aft_ins1;
DROP TRIGGER trig_aft_ins1_1;
DROP TRIGGER trig_aft_ins1_2;

DROP TRIGGER trig_bef_del2;
DROP TRIGGER trig_aft_del2;
DROP TRIGGER trig_bef_ins2;
DROP TRIGGER trig_aft_ins2;

DROP TABLE trigger_actions1;
DROP TABLE trigger_actions2;
DROP TABLE with_trigger2;
DROP TABLE with_trigger;
