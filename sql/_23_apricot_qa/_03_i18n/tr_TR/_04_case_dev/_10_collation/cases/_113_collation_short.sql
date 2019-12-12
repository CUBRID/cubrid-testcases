--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'xt');
INSERT INTO coll_test (id, s) values (19, 'xyx');
INSERT INTO coll_test (id, s) values (16, 'xx');
INSERT INTO coll_test (id, s) values (13, 'xü');
INSERT INTO coll_test (id, s) values (10, 'xŭx');
INSERT INTO coll_test (id, s) values (7, 'xux');
INSERT INTO coll_test (id, s) values (4, 'xŭ');
INSERT INTO coll_test (id, s) values (1, 'xu');
INSERT INTO coll_test (id, s) values (20, 'xÿx');
INSERT INTO coll_test (id, s) values (17, 'xy');
INSERT INTO coll_test (id, s) values (14, 'xüx');
INSERT INTO coll_test (id, s) values (11, 'xûx');
INSERT INTO coll_test (id, s) values (8, 'xúx');
INSERT INTO coll_test (id, s) values (5, 'xû');
INSERT INTO coll_test (id, s) values (2, 'xú');
INSERT INTO coll_test (id, s) values (21, 'xz');
INSERT INTO coll_test (id, s) values (18, 'xÿ');
INSERT INTO coll_test (id, s) values (15, 'xv');
INSERT INTO coll_test (id, s) values (12, 'xūx');
INSERT INTO coll_test (id, s) values (9, 'xùx');
INSERT INTO coll_test (id, s) values (6, 'xū');
INSERT INTO coll_test (id, s) values (3, 'xù');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;