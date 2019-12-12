--exceptional case:
--an error occurs in a trigger action.


CREATE TABLE with_trigger(a int primary key auto_increment, b char(10), c int unique);
INSERT INTO with_trigger(b, c) VALUES ('AAA', 1), ('BBB', 2), ('CCC', 3);
SELECT * FROM with_trigger order by 1;

CREATE TABLE trigger_actions(id int auto_increment, a int unique, b char(20));

CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions(a, b) VALUES (1, 'BEFORE INSERT');
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions(a, b) VALUES (2, 'AFTER INSERT');

REPLACE INTO with_trigger(b, c) VALUES ('DDD', 4);
SELECT * FROM trigger_actions order by 1;
SELECT * FROM with_trigger order by 1;

--Error occurs in trigger action
REPLACE INTO with_trigger(b, c) VALUES ('FFF', 4);
SELECT * FROM trigger_actions order by 1;
SELECT * FROM with_trigger order by 1;

DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;

DROP TABLE trigger_actions;
DROP TABLE with_trigger;
