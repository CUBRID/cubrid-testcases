--insert multiple rows CASE 2.
--trigger: 1) before update  2) after update
--trigger action: insert.


CREATE TABLE with_trigger(a int unique, b int, c int);
INSERT INTO with_trigger VALUES (1, 11, 1), (2, 22, 2), (3, 33, 3);
SELECT * FROM with_trigger order by a;

CREATE TABLE trigger_actions(a int auto_increment, b int, c char(20));

CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
        INSERT INTO trigger_actions(b, c) VALUES (11, 'BEFORE UPDATE');
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE
        INSERT INTO trigger_actions (b, c) VALUES (22, 'AFTER UPDATE');


INSERT INTO with_trigger VALUES(1, 2, 3), (2, 3, 4), (3, 4, 5) ON DUPLICATE KEY UPDATE c=a+b;
SELECT * FROM trigger_actions order by a;
SELECT * FROM with_trigger order by a;

DROP TRIGGER trig_bef_upd;
DROP TRIGGER trig_aft_upd;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
