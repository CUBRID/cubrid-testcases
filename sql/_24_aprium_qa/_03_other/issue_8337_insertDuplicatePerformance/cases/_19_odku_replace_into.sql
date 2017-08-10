drop table if exists  with_trigger,trigger_actions; 
CREATE TABLE with_trigger (id INT UNIQUE);

INSERT INTO with_trigger VALUES (11);

CREATE TABLE trigger_actions (val INT);
 
CREATE TRIGGER trig_1 BEFORE INSERT ON with_trigger EXECUTE INSERT INTO trigger_actions VALUES (1);

CREATE TRIGGER trig_2 BEFORE UPDATE ON with_trigger EXECUTE INSERT INTO trigger_actions VALUES (2);

CREATE TRIGGER trig_3 BEFORE DELETE ON with_trigger EXECUTE INSERT INTO trigger_actions VALUES (3);

INSERT INTO with_trigger VALUES (11) ON DUPLICATE KEY UPDATE id=22;

SELECT * FROM with_trigger;

REPLACE INTO with_trigger VALUES(22);

PREPARE st FROM 'REPLACE INTO with_trigger VALUES(?)'

EXECUTE st USING 22;

SELECT * FROM trigger_actions order by 1;

SELECT * FROM with_trigger  order by 1;;

drop table if exists with_trigger,trigger_actions;
