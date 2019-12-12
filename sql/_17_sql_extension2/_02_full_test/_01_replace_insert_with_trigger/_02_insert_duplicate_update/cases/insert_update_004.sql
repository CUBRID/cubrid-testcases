--insert into a table with a primary key and a unique index.
--trigger: 1) before insert  2) after insert  3) before update  4) after update
--trigger action: insert into 2 tables.


CREATE TABLE with_trigger(a int primary key, b char(10), c int unique);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by 1;

CREATE TABLE trigger_actions1(id int auto_increment, a int, b char(20));
CREATE TABLE trigger_actions2(id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions1 (a, b) VALUES (1, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions1 (a, b) VALUES (2, 'AFTER INSERT');
CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
        INSERT INTO trigger_actions2 (a, b) VALUES (3, 'BEFORE UPDATE');
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE
        INSERT INTO trigger_actions2 (a, b) VALUES (4, 'AFTER UPDATE');

INSERT INTO with_trigger VALUES (4, 'DDD', 4) ON DUPLICATE KEY UPDATE b='DUPLICATED';
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;
SELECT * FROM with_trigger order by 1;

INSERT INTO with_trigger VALUES (4, 'FFF', 4) ON DUPLICATE KEY UPDATE b='DUPLICATED';
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;
SELECT * FROM with_trigger order by 1;

DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;
DROP TRIGGER trig_bef_upd;
DROP TRIGGER trig_aft_upd;

DROP TABLE trigger_actions1;
DROP TABLE trigger_actions2;
DROP TABLE with_trigger;
