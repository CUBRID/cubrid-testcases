--1.insert into a table with a foreign key
--2. insert into a table the index of which a foreign key references
--trigger: 1) before insert  2) after insert  3) before update  4) after update


CREATE TABLE with_trigger(a int not null primary key, b char(10), c int);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3), (4, 'DDD', 4);
SELECT * FROM with_trigger order by 1;

CREATE TABLE with_trigger2(a string unique, b int,
                           CONSTRAINT fk_id FOREIGN KEY(b) REFERENCES with_trigger(a)
                           ON DELETE CASCADE ON UPDATE SET NULL);
INSERT INTO with_trigger2 VALUES ('AAA', 1), ('BBB', 2), ('CCC', 3);
SELECT * FROM with_trigger2 order by 1;


--triggers of the table which is referenced
CREATE TABLE trigger_actions1(id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_ins1 BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (1, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins1 AFTER INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (2, 'AFTER INSERT');
CREATE TRIGGER trig_bef_upd1 BEFORE UPDATE ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (3, 'BEFORE UPDATE');
CREATE TRIGGER trig_aft_upd1 AFTER UPDATE ON with_trigger EXECUTE
	INSERT INTO trigger_actions1(a, b) VALUES (4, 'AFTER UPDATE');


--triggers of the table with a foreign key
CREATE TABLE trigger_actions2(id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_ins2 BEFORE INSERT ON with_trigger2 EXECUTE
        INSERT INTO trigger_actions2(a, b) VALUES (1, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins2 AFTER INSERT ON with_trigger2 EXECUTE
        INSERT INTO trigger_actions2(a, b) VALUES (2, 'AFTER INSERT');
CREATE TRIGGER trig_bef_upd2 BEFORE UPDATE ON with_trigger2 EXECUTE
        INSERT INTO trigger_actions2(a, b) VALUES (3, 'BEFORE UPDATE');
CREATE TRIGGER trig_aft_upd2 AFTER UPDATE ON with_trigger2 EXECUTE
        INSERT INTO trigger_actions2(a, b) VALUES (4, 'AFTER UPDATE');


--insert into a table with a foreign key
INSERT INTO with_trigger VALUES (3, 'EEE', 5) ON DUPLICATE KEY UPDATE b='DUPLICATED', a=a+c;
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;
SELECT * FROM with_trigger order by 1;
SELECT * FROM with_trigger2 order by 1;

INSERT INTO with_trigger VALUES (1, 'FFF', 8) ON DUPLICATE KEY UPDATE b='DUPLICATED', a=a-c;
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;
SELECT * FROM with_trigger order by 1;
SELECT * FROM with_trigger2 order by 1;

DROP TRIGGER trig_bef_ins1;
DROP TRIGGER trig_aft_ins1;
DROP TRIGGER trig_bef_upd1;
DROP TRIGGER trig_aft_upd1;

DROP TRIGGER trig_bef_ins2;
DROP TRIGGER trig_aft_ins2;
DROP TRIGGER trig_bef_upd2;
DROP TRIGGER trig_aft_upd2;

DROP TABLE trigger_actions1;
DROP TABLE trigger_actions2;
DROP TABLE with_trigger2;
DROP TABLE with_trigger;
