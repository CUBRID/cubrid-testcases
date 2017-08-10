--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'xh');
INSERT INTO coll_test (id, s) values (17, 'xīx');
INSERT INTO coll_test (id, s) values (15, 'xïx');
INSERT INTO coll_test (id, s) values (13, 'xĭx');
INSERT INTO coll_test (id, s) values (11, 'xíx');
INSERT INTO coll_test (id, s) values (9, 'xix');
INSERT INTO coll_test (id, s) values (7, 'xÏx');
INSERT INTO coll_test (id, s) values (5, 'xĬx');
INSERT INTO coll_test (id, s) values (3, 'xÍx');
INSERT INTO coll_test (id, s) values (1, 'xıx');
INSERT INTO coll_test (id, s) values (18, 'xj');
INSERT INTO coll_test (id, s) values (16, 'xi̇x');
INSERT INTO coll_test (id, s) values (14, 'xîx');
INSERT INTO coll_test (id, s) values (12, 'xìx');
INSERT INTO coll_test (id, s) values (10, 'xİx');
INSERT INTO coll_test (id, s) values (8, 'xĪx');
INSERT INTO coll_test (id, s) values (6, 'xÎx');
INSERT INTO coll_test (id, s) values (4, 'xÌx');
INSERT INTO coll_test (id, s) values (2, 'xIx');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;