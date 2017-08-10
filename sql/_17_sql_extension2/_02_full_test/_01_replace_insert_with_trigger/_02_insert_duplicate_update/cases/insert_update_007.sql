--insert into a table with a unique index.
--trigger: 1) before delete  2) after delete  3) before insert  4) after insert 5) before update  6) after update
--trigger action: insert/delete/update 1 table.


CREATE TABLE with_trigger(a float, b date unique, c string, d clob);
INSERT INTO with_trigger VALUES (1.1, '2010-09-26', 'AAA', char_to_clob('aaa')), (2.2, '2009-04-15', 'BBB', char_to_clob('bbb')), (3.3, '02/28/2008', 'CCC', char_to_clob('ccc'));
SELECT a, b, c, clob_to_char(d) FROM with_trigger order by 1;

CREATE TABLE trigger_actions(id int auto_increment, a smallint, b string, c numeric);

CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions (a, b, c) VALUES (11, 'BEFORE DELETE', 11);
CREATE TRIGGER trig_aft_del AFTER DELETE ON with_trigger EXECUTE
	UPDATE trigger_actions SET b='AFTER DELETE' WHERE a=11;
CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions (a, b, c) VALUES (33, 'BEFORE INSERT', 33);
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	DELETE FROM trigger_actions WHERE c=33;
CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
	INSERT INTO trigger_actions (a, b, c) VALUES (55, 'BEFORE UPDATE', 55);
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE
	UPDATE trigger_actions SET c=44 WHERE a=33;

INSERT INTO with_trigger VALUES (4.4, '2010-09-26', 'DDD', char_to_clob('ddd')) ON DUPLICATE KEY UPDATE c='DUPLICATED', a=a+10;
SELECT a, b, c, clob_to_char(d) FROM with_trigger order by 1;
SELECT * FROM trigger_actions order by 1;

INSERT INTO with_trigger VALUES (5.5, '2000-11-08', 'FFF', char_to_clob('fff')) ON DUPLICATE KEY UPDATE c='DUPLICATED', a=a+10;
SELECT a, b, c, clob_to_char(d) FROM with_trigger order by 1;
SELECT * FROM trigger_actions order by 1;

INSERT INTO with_trigger VALUES (6.6, '11/08/2000', 'GGG', char_to_clob('ggg')) ON DUPLICATE KEY UPDATE c='DUPLICATED', a=a+10;
SELECT a, b, c, clob_to_char(d) FROM with_trigger order by 1;
SELECT * FROM trigger_actions order by 1;

DELETE FROM with_trigger;

DROP TRIGGER trig_bef_del;
DROP TRIGGER trig_aft_del;
DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;
DROP TRIGGER trig_bef_upd;
DROP TRIGGER trig_aft_upd;

DROP TABLE with_trigger;
DROP TABLE trigger_actions;
