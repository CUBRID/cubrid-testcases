--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'xb');
INSERT INTO coll_test (id, s) values (17, 'xÇx');
INSERT INTO coll_test (id, s) values (15, 'XÇ');
INSERT INTO coll_test (id, s) values (13, 'xÇ');
INSERT INTO coll_test (id, s) values (11, 'xCx');
INSERT INTO coll_test (id, s) values (9, 'XC');
INSERT INTO coll_test (id, s) values (7, 'xC');
INSERT INTO coll_test (id, s) values (5, 'xBx');
INSERT INTO coll_test (id, s) values (3, 'XB');
INSERT INTO coll_test (id, s) values (1, 'xB');
INSERT INTO coll_test (id, s) values (18, 'xd');
INSERT INTO coll_test (id, s) values (16, 'xçx');
INSERT INTO coll_test (id, s) values (14, 'Xç');
INSERT INTO coll_test (id, s) values (12, 'xç');
INSERT INTO coll_test (id, s) values (10, 'xcx');
INSERT INTO coll_test (id, s) values (8, 'Xc');
INSERT INTO coll_test (id, s) values (6, 'xc');
INSERT INTO coll_test (id, s) values (4, 'xbx');
INSERT INTO coll_test (id, s) values (2, 'Xb');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;