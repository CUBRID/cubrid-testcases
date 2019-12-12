--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'xo');
INSERT INTO coll_test (id, s) values (17, 'xöx');
INSERT INTO coll_test (id, s) values (15, 'xōx');
INSERT INTO coll_test (id, s) values (13, 'xôx');
INSERT INTO coll_test (id, s) values (11, 'xòx');
INSERT INTO coll_test (id, s) values (9, 'xox');
INSERT INTO coll_test (id, s) values (7, 'xœ');
INSERT INTO coll_test (id, s) values (5, 'xø');
INSERT INTO coll_test (id, s) values (3, 'xŏ');
INSERT INTO coll_test (id, s) values (1, 'xó');
INSERT INTO coll_test (id, s) values (18, 'xp');
INSERT INTO coll_test (id, s) values (16, 'xö');
INSERT INTO coll_test (id, s) values (14, 'xøx');
INSERT INTO coll_test (id, s) values (12, 'xŏx');
INSERT INTO coll_test (id, s) values (10, 'xóx');
INSERT INTO coll_test (id, s) values (8, 'xœx');
INSERT INTO coll_test (id, s) values (6, 'xō');
INSERT INTO coll_test (id, s) values (4, 'xô');
INSERT INTO coll_test (id, s) values (2, 'xò');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;