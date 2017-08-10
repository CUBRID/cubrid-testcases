--Replace Statement with trigger actions supported
CREATE TABLE with_trigger (id INT UNIQUE);
INSERT INTO with_trigger VALUES (11);
CREATE TABLE trigger_actions (val INT);

CREATE TRIGGER trig_1 BEFORE INSERT ON with_trigger EXECUTE
    INSERT INTO trigger_actions VALUES (1);
CREATE TRIGGER TRIG_2 BEFORE UPDATE ON with_trigger EXECUTE
    INSERT INTO trigger_actions VALUES (2);

REPLACE INTO with_trigger VALUES (22);
REPLACE INTO with_trigger VALUES (22);

SELECT * FROM trigger_actions order by 1;


DROP TRIGGER trig_1;
DROP TRIGGER trig_2;
DROP TABLE with_trigger;
DROP TABLE trigger_actions;



