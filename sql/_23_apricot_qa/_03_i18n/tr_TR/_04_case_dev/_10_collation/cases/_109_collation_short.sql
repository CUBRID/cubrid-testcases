--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'xm');
INSERT INTO coll_test (id, s) values (17, 'xÑx');
INSERT INTO coll_test (id, s) values (15, 'xNx');
INSERT INTO coll_test (id, s) values (13, 'XÑ');
INSERT INTO coll_test (id, s) values (11, 'xÑ');
INSERT INTO coll_test (id, s) values (9, 'XN');
INSERT INTO coll_test (id, s) values (7, 'xN');
INSERT INTO coll_test (id, s) values (5, 'xMx');
INSERT INTO coll_test (id, s) values (3, 'XM');
INSERT INTO coll_test (id, s) values (1, 'xM');
INSERT INTO coll_test (id, s) values (18, 'xo');
INSERT INTO coll_test (id, s) values (16, 'xñx');
INSERT INTO coll_test (id, s) values (14, 'xnx');
INSERT INTO coll_test (id, s) values (12, 'Xñ');
INSERT INTO coll_test (id, s) values (10, 'xñ');
INSERT INTO coll_test (id, s) values (8, 'Xn');
INSERT INTO coll_test (id, s) values (6, 'xn');
INSERT INTO coll_test (id, s) values (4, 'xmx');
INSERT INTO coll_test (id, s) values (2, 'Xm');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;