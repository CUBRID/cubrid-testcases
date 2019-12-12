CREATE TABLE with_trigger(a int unique, b char(10), c int);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by a;

CREATE TABLE with_trigger2(a int unique, b char(10), c int);
INSERT INTO with_trigger2 VALUES (1, 'DDD', 4), (2, 'EEE', 5), (3, 'FFF', 6);
SELECT * FROM with_trigger2 order by a;

CREATE TABLE trigger_actions(a int auto_increment, b int, c char(20));

CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
        INSERT INTO trigger_actions(b, c) VALUES (11, 'BEFORE UPDATE');
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE
        INSERT INTO trigger_actions (b, c) VALUES (22, 'AFTER UPDATE');


INSERT INTO with_trigger SELECT * FROM with_trigger2 ON DUPLICATE KEY UPDATE b='DUPLICATED', c=100;
SELECT * FROM trigger_actions order by a;
SELECT * FROM with_trigger order by a;

DROP TRIGGER trig_bef_upd;
DROP TRIGGER trig_aft_upd;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
DROP TABLE with_trigger2;
