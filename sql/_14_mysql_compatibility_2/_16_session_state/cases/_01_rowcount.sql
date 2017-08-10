--basic table
CREATE TABLE t (i int);

INSERT INTO t VALUES(1);

SELECT if (ROW_COUNT() = 1, 'ok', 'nok');

SELECT if (ROW_COUNT() = -1, 'ok', 'nok');

INSERT INTO t VALUES (2),(3),(4),(5),(6);

SELECT if (ROW_COUNT() = 5, 'ok', 'nok');

DELETE FROM t WHERE i <=5;

SELECT if (ROW_COUNT() = 5, 'ok', 'nok');

INSERT INTO t VALUES (1),(2),(3),(4),(5);

UPDATE t SET i = i + 1;

SELECT if (ROW_COUNT() = 6, 'ok', 'nok');

CREATE TABLE u (i int);

INSERT INTO u SELECT * FROM t;

SELECT if (ROW_COUNT () = (SELECT COUNT(i) FROM t), 'ok', 'nok');

DROP TABLE u;
DROP TABLE t;

--triggers
CREATE TABLE a (i int);
CREATE TABLE b (i int);

CREATE TRIGGER bef_a BEFORE INSERT ON a EXECUTE INSERT INTO b VALUES(new.i);
CREATE TRIGGER aft_a AFTER INSERT ON a EXECUTE INSERT INTO b VALUES(obj.i);

INSERT INTO a VALUES(1);

SELECT if (ROW_COUNT() = 1, 'ok', 'nok');

SELECT if (ROW_COUNT() = -1, 'ok', 'nok');

INSERT INTO a VALUES (2),(3),(4),(5),(6);

SELECT if (ROW_COUNT() = 5, 'ok', 'nok');

CREATE TRIGGER bef_del_a BEFORE DELETE ON a EXECUTE INSERT INTO b VALUES(obj.i);
CREATE TRIGGER aft_del_a AFTER DELETE ON a EXECUTE DELETE FROM b WHERE i = 3;

DELETE FROM a WHERE i <=5;

SELECT if (ROW_COUNT() = 5, 'ok', 'nok');

INSERT INTO a VALUES (1),(2),(3),(4),(5);

CREATE TRIGGER bef_upd_a BEFORE UPDATE ON a EXECUTE INSERT INTO b VALUES(obj.i);
CREATE TRIGGER aft_upd_a AFTER UPDATE ON a EXECUTE DELETE FROM b WHERE i = 3;

UPDATE a SET i = 1;

SELECT if (ROW_COUNT() = 6, 'ok', 'nok');

drop table a;
drop table b;

--INSERT ... ON DUPLICATE KEY UPDATE
CREATE TABLE t (i int unique, s string);

INSERT INTO t VALUES (1, '1'), (2, '2'), (3, '3');

INSERT INTO t (i, s) VALUES (2, '2') ON DUPLICATE KEY UPDATE s = 'updated';

SELECT if (ROW_COUNT() = 2, 'ok', 'nok');

INSERT INTO t (i, s) VALUES (4, '4') ON DUPLICATE KEY UPDATE s = 'updated';

SELECT if (ROW_COUNT() = 1, 'ok', 'nok');

DROP TABLE t;
--REPLACE INTO
CREATE TABLE t (i int unique, s string);

INSERT INTO t VALUES (1, '1'), (2, '2'), (3, '3');

REPLACE INTO t (i, s) VALUES (2, '2');

SELECT if (ROW_COUNT() = 2, 'ok', 'nok');

REPLACE INTO t (i, s) VALUES (4, '4');

SELECT if (ROW_COUNT() = 1, 'ok', 'nok');

DROP TABLE t;

