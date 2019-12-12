--+ holdcas on;
set names utf8;
CREATE TABLE coll_test_ro (id INTEGER, s1 VARCHAR(10) collate utf8_ro_cs, s2 VARCHAR(10) collate utf8_ro_cs, s3 VARCHAR(10) collate utf8_ro_cs);

INSERT INTO coll_test_ro (id, s1, s2, s3) values (0, 'a', 'A', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (1, 'ă', 'Ă', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (2, 'â', 'Â', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (3, 'b', 'B', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (4, 'c', 'C', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (5, 'd', 'D', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (6, 'e', 'E', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (7, 'f', 'F', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (8, 'g', 'G', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (9, 'h', 'H', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (10, 'i', 'I', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (11, 'î', 'Î', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (12, 'j', 'J', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (13, 'k', 'K', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (14, 'l', 'L', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (15, 'm', 'M', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (16, 'n', 'N', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (17, 'o', 'O', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (18, 'p', 'P', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (19, 'q', 'Q', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (20, 'r', 'R', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (21, 's', 'S', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (22, 'ş', 'Ş', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (23, 'ș', 'Ș', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (24, 't', 'T', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (25, 'ţ', 'Ţ', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (26, 'ț', 'Ț', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (27, 'u', 'U', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (28, 'v', 'V', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (29, 'w', 'W', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (30, 'x', 'X', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (31, 'y', 'Y', '');
INSERT INTO coll_test_ro (id, s1, s2, s3) values (32, 'z', 'Z', '');


SELECT id, s1 FROM coll_test_ro ORDER BY s1,id;
SELECT id, s2 FROM coll_test_ro ORDER BY s2,id;
SELECT id, s1, s2 FROM coll_test_ro WHERE s1 <> lower(s2) ORDER BY s1;
SELECT id, s1, s2 FROM coll_test_ro WHERE s2 <> upper(s1) ORDER BY s1;

UPDATE coll_test_ro SET s3=upper(s1);
SELECT id, s1, s2, s3 FROM coll_test_ro WHERE s3 <> s2 ORDER BY s3;

UPDATE coll_test_ro SET s3=lower(s2);
SELECT id, s1, s2, s3 FROM coll_test_ro WHERE s3 <> s1 ORDER BY s3;


CREATE TABLE coll_test_ro2 (id INTEGER, s varchar(10) collate utf8_ro_cs);
INSERT INTO coll_test_ro2 (id, s) SELECT id, s1 FROM coll_test_ro;
INSERT INTO coll_test_ro2 (id, s) SELECT id + 33, s2 FROM coll_test_ro;
SELECT id, s FROM coll_test_ro2 ORDER BY s,id;

DROP TABLE coll_test_ro2;
DROP TABLE coll_test_ro;

set names iso88591;
commit;
--+ holdcas off;
