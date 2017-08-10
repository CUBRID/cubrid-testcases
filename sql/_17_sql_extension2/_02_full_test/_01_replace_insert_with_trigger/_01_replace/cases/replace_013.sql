--replace into a table with 2 unique indexes, one replace statement affects multiple rows.
--trigger: 1) before delete  2) after delete  3) before insert  4) after insert
--trigger action: insert into 1 table.


CREATE TABLE with_trigger(a int unique, b char(10), c int unique);
INSERT INTO with_trigger VALUES (1, 'AAA', 1), (2, 'BBB', 2), (3, 'CCC', 3);
SELECT * FROM with_trigger order by 1;

CREATE TABLE trigger_actions (id int auto_increment, a int, b char(20));

CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
        INSERT INTO trigger_actions(a, b) VALUES (1, 'BEFORE DELETE');
CREATE TRIGGER trig_aft_del AFTER DELETE ON with_trigger EXECUTE
        INSERT INTO trigger_actions(a, b) VALUES (2, 'AFTER DELETE');
CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
        INSERT INTO trigger_actions(a, b) VALUES (3, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
        INSERT INTO trigger_actions(a, b) VALUES (4, 'AFTER INSERT');


REPLACE INTO with_trigger VALUES (1, 'DDD', 3);
SELECT * FROM trigger_actions order by 1;
SELECT * FROM with_trigger order by 1;

DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;
DROP TRIGGER trig_bef_del;
DROP TRIGGER trig_aft_del;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
