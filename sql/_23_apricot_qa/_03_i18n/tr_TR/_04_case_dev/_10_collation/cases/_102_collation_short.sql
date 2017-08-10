--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10)  collate utf8_tr_cs);

INSERT INTO coll_test (id, s) values (0, 'xa');
INSERT INTO coll_test (id, s) values (17, 'xāx');
INSERT INTO coll_test (id, s) values (15, 'xåx');
INSERT INTO coll_test (id, s) values (13, 'xăx');
INSERT INTO coll_test (id, s) values (11, 'xáx');
INSERT INTO coll_test (id, s) values (9, 'xæx');
INSERT INTO coll_test (id, s) values (7, 'xā');
INSERT INTO coll_test (id, s) values (5, 'xå');
INSERT INTO coll_test (id, s) values (3, 'xă');
INSERT INTO coll_test (id, s) values (1, 'xá');
INSERT INTO coll_test (id, s) values (18, 'xb');
INSERT INTO coll_test (id, s) values (16, 'xäx');
INSERT INTO coll_test (id, s) values (14, 'xâx');
INSERT INTO coll_test (id, s) values (12, 'xàx');
INSERT INTO coll_test (id, s) values (10, 'xax');
INSERT INTO coll_test (id, s) values (8, 'xæ');
INSERT INTO coll_test (id, s) values (6, 'xä');
INSERT INTO coll_test (id, s) values (4, 'xâ');
INSERT INTO coll_test (id, s) values (2, 'xà');

SELECT id, s FROM coll_test ORDER BY s;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;