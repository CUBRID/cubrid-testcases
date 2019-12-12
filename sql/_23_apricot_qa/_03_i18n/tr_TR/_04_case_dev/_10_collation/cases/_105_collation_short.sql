--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'xf');
INSERT INTO coll_test (id, s) values (17, 'xĞx');
INSERT INTO coll_test (id, s) values (15, 'XĞ');
INSERT INTO coll_test (id, s) values (13, 'xĞ');
INSERT INTO coll_test (id, s) values (11, 'xGx');
INSERT INTO coll_test (id, s) values (9, 'XG');
INSERT INTO coll_test (id, s) values (7, 'xG');
INSERT INTO coll_test (id, s) values (5, 'xFx');
INSERT INTO coll_test (id, s) values (3, 'XF');
INSERT INTO coll_test (id, s) values (1, 'xF');
INSERT INTO coll_test (id, s) values (18, 'xh');
INSERT INTO coll_test (id, s) values (16, 'xğx');
INSERT INTO coll_test (id, s) values (14, 'Xğ');
INSERT INTO coll_test (id, s) values (12, 'xğ');
INSERT INTO coll_test (id, s) values (10, 'xgx');
INSERT INTO coll_test (id, s) values (8, 'Xg');
INSERT INTO coll_test (id, s) values (6, 'xg');
INSERT INTO coll_test (id, s) values (4, 'xfx');
INSERT INTO coll_test (id, s) values (2, 'Xf');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;