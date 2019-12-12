--replace into a table with a primary key and a unique index.
--trigger: 1) before delete  2) after delete  3) before insert  4) after insert 5) before update  6) after update
--trigger action: insert/delete/update 2 tables.

CREATE TABLE with_trigger(a double primary key, b date unique, c string, d clob);
INSERT INTO with_trigger VALUES (1.1, '2010-09-26', 'AAA', char_to_clob('aaa')), (2.2, '2009-04-15', 'BBB', char_to_clob('bbb')), (3.3, '02/28/2008', 'CCC', char_to_clob('ccc'));
SELECT a, b, c, clob_to_char(d) FROM with_trigger order by 1;

CREATE TABLE trigger_actions1(id int auto_increment, a smallint, b string, c numeric);
CREATE TABLE trigger_actions2(id int auto_increment, a bigint, b varchar(20), c monetary);

CREATE TRIGGER trig_bef_del BEFORE DELETE ON with_trigger EXECUTE
	INSERT INTO trigger_actions1 (a, b, c) VALUES (11, 'BEFORE DELETE', 11);
CREATE TRIGGER trig_aft_del AFTER DELETE ON with_trigger EXECUTE
	UPDATE trigger_actions1 SET b='AFTER DELETE' WHERE a=11;
CREATE TRIGGER trig_bef_ins BEFORE INSERT ON with_trigger EXECUTE
	INSERT INTO trigger_actions2 (a, b, c) VALUES (33, 'BEFORE INSERT', 33);
CREATE TRIGGER trig_aft_ins AFTER INSERT ON with_trigger EXECUTE
	DELETE FROM trigger_actions2 WHERE c=33;
CREATE TRIGGER trig_bef_upd BEFORE UPDATE ON with_trigger EXECUTE
	INSERT INTO trigger_actions2 (a, b, c) VALUES (55, 'BEFORE UPDATE', 55);
CREATE TRIGGER trig_aft_upd AFTER UPDATE ON with_trigger EXECUTE
	UPDATE trigger_actions2 SET c=44 WHERE a=33;

REPLACE INTO with_trigger VALUES (4.4, '2010-09-26', 'DDD', char_to_clob('ddd'));
SELECT a, b, c, clob_to_char(d) FROM with_trigger order by 1;
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;

REPLACE INTO with_trigger VALUES (4.4, '2000-11-08', 'FFF', char_to_clob('fff'));
SELECT a, b, c, clob_to_char(d) FROM with_trigger order by 1;
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;

REPLACE INTO with_trigger VALUES (4.4, '11/08/2000', 'GGG', char_to_clob('ggg'));
SELECT a, b, c, clob_to_char(d) FROM with_trigger order by 1;
SELECT * FROM trigger_actions1 order by 1;
SELECT * FROM trigger_actions2 order by 1;

DELETE FROM with_trigger;

DROP TRIGGER trig_bef_del;
DROP TRIGGER trig_aft_del;
DROP TRIGGER trig_bef_ins;
DROP TRIGGER trig_aft_ins;
DROP TRIGGER trig_bef_upd;
DROP TRIGGER trig_aft_upd;

DROP TABLE with_trigger;
DROP TABLE trigger_actions1;
DROP TABLE trigger_actions2;
