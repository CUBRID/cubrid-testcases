--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10) collate utf8_ja_exp );

INSERT INTO coll_test (id, s) values (10, 'x۞x');
INSERT INTO coll_test (id, s) values (1, 'x🂡x');
INSERT INTO coll_test (id, s) values (2, 'x🃟x');
INSERT INTO coll_test (id, s) values (3, 'x𐒢x');
INSERT INTO coll_test (id, s) values (4, 'x𒑊x');
INSERT INTO coll_test (id, s) values (5, 'x𐹢x');
INSERT INTO coll_test (id, s) values (6, 'x𒐶x');
INSERT INTO coll_test (id, s) values (7, 'x𝟺x');
INSERT INTO coll_test (id, s) values (8, 'x𝍤x');
INSERT INTO coll_test (id, s) values (9, 'x𒐑x');
INSERT INTO coll_test (id, s) values (10, 'x𝟽x');
INSERT INTO coll_test (id, s) values (10, 'xñx');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names utf8;
commit;
--+ holdcas off;
