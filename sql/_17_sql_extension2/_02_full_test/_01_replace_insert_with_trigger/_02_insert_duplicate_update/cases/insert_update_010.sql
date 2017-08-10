--exceptional case: an error occurs in a trigger action.
--trigger: 1) before update  2) after update
--trigger action: insert

CREATE TABLE with_trigger(a int primary key auto_increment, b char(10), c int unique);
INSERT INTO with_trigger(b, c) VALUES ('AAA', 1), ('BBB', 2), ('CCC', 3);
SELECT * FROM with_trigger order by 1;

CREATE TABLE trigger_actions(id int auto_increment, a int unique, b char(20));

CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
        INSERT INTO trigger_actions (a, b) VALUES (11, 'BEFORE UPDATE');
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE
        INSERT INTO trigger_actions (a, b) VALUES (22, 'AFTER UPDATE');


INSERT INTO with_trigger(b, c) VALUES ('DDD', 4) ON DUPLICATE KEY UPDATE b='DUPLICATED';
SELECT * FROM trigger_actions order by 1;
SELECT * FROM with_trigger order by 1;

INSERT INTO with_trigger(b, c) VALUES ('DDD', 4) ON DUPLICATE KEY UPDATE b='DUPLICATED';
SELECT * FROM trigger_actions order by 1;
SELECT * FROM with_trigger order by 1;

--Error occurs in trigger action
INSERT INTO with_trigger(b, c) VALUES ('FFF', 4) ON DUPLICATE KEY UPDATE b='DUPLICATED';
SELECT * FROM trigger_actions order by 1;
SELECT * FROM with_trigger order by 1;

DROP TRIGGER trig_bef_upd;
DROP TRIGGER trig_aft_upd;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
