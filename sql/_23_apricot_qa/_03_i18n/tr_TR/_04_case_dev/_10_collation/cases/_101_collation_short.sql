--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'x');
INSERT INTO coll_test (id, s) values (13, 'X2');
INSERT INTO coll_test (id, s) values (10, 'X12');
INSERT INTO coll_test (id, s) values (7, 'X0');
INSERT INTO coll_test (id, s) values (4, 'X.');
INSERT INTO coll_test (id, s) values (1, 'X');
INSERT INTO coll_test (id, s) values (14, 'x2x');
INSERT INTO coll_test (id, s) values (11, 'x12x');
INSERT INTO coll_test (id, s) values (8, 'x0x');
INSERT INTO coll_test (id, s) values (5, 'x.x');
INSERT INTO coll_test (id, s) values (2, 'x x');
INSERT INTO coll_test (id, s) values (15, 'xa');
INSERT INTO coll_test (id, s) values (12, 'x2');
INSERT INTO coll_test (id, s) values (9, 'x12');
INSERT INTO coll_test (id, s) values (6, 'x0');
INSERT INTO coll_test (id, s) values (3, 'x.');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;