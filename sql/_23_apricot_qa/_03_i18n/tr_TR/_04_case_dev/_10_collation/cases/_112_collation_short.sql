--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'xr');
INSERT INTO coll_test (id, s) values (23, 'XŞ');
INSERT INTO coll_test (id, s) values (19, 'xSx');
INSERT INTO coll_test (id, s) values (15, 'xSsx');
INSERT INTO coll_test (id, s) values (11, 'xß');
INSERT INTO coll_test (id, s) values (7, 'Xss');
INSERT INTO coll_test (id, s) values (3, 'xss');
INSERT INTO coll_test (id, s) values (26, 'xt');
INSERT INTO coll_test (id, s) values (22, 'Xş');
INSERT INTO coll_test (id, s) values (18, 'xsx');
INSERT INTO coll_test (id, s) values (14, 'xsSx');
INSERT INTO coll_test (id, s) values (10, 'XSS');
INSERT INTO coll_test (id, s) values (6, 'xSS');
INSERT INTO coll_test (id, s) values (2, 'xs');
INSERT INTO coll_test (id, s) values (25, 'xŞx');
INSERT INTO coll_test (id, s) values (21, 'xŞ');
INSERT INTO coll_test (id, s) values (17, 'xßx');
INSERT INTO coll_test (id, s) values (13, 'xssx');
INSERT INTO coll_test (id, s) values (9, 'XSs');
INSERT INTO coll_test (id, s) values (5, 'xSs');
INSERT INTO coll_test (id, s) values (1, 'xrx');
INSERT INTO coll_test (id, s) values (24, 'xşx');
INSERT INTO coll_test (id, s) values (20, 'xş');
INSERT INTO coll_test (id, s) values (16, 'xSSx');
INSERT INTO coll_test (id, s) values (12, 'Xß');
INSERT INTO coll_test (id, s) values (8, 'XsS');
INSERT INTO coll_test (id, s) values (4, 'xsS');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;