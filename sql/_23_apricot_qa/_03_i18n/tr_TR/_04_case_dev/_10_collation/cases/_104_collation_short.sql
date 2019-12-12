--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'xd');
INSERT INTO coll_test (id, s) values (13, 'xëx');
INSERT INTO coll_test (id, s) values (10, 'xèx');
INSERT INTO coll_test (id, s) values (7, 'xē');
INSERT INTO coll_test (id, s) values (4, 'xĕ');
INSERT INTO coll_test (id, s) values (1, 'xe');
INSERT INTO coll_test (id, s) values (14, 'xēx');
INSERT INTO coll_test (id, s) values (11, 'xĕx');
INSERT INTO coll_test (id, s) values (8, 'xex');
INSERT INTO coll_test (id, s) values (5, 'xê');
INSERT INTO coll_test (id, s) values (2, 'xé');
INSERT INTO coll_test (id, s) values (15, 'xf');
INSERT INTO coll_test (id, s) values (12, 'xêx');
INSERT INTO coll_test (id, s) values (9, 'xéx');
INSERT INTO coll_test (id, s) values (6, 'xë');
INSERT INTO coll_test (id, s) values (3, 'xè');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;