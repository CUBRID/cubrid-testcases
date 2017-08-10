-- CUBRIDSUS-4577
CREATE TABLE with_trigger(a int primary key, b varchar(20), c int);
INSERT INTO with_trigger VALUES (1, 'AAA', 11), (2, 'BBB', 22), (3, 'CCC', 33);
SELECT a, b, c FROM with_trigger order by 1;

CREATE TABLE trigger_actions(a smallint primary key, b char(20), c numeric);
INSERT INTO trigger_actions(a,b,c) VALUES (11, 'BEFORE UPDATE', 11);

CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
		INSERT INTO trigger_actions (a, b, c) VALUES (11, 'BEFORE UPDATE', 11) ON DUPLICATE KEY UPDATE b='DUPLICATED', c=c+50;

INSERT INTO with_trigger VALUES (3, 'DDD', 44) ON DUPLICATE KEY UPDATE b='DUPLICATE', c=44;
SELECT * FROM trigger_actions order by 1;



drop table with_trigger;
drop table trigger_actions;


