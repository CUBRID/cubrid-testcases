--+ holdcas on;
set names utf8;
CREATE TABLE coll_test (id INTEGER, s VARCHAR(10) collate utf8_ja_exp );

INSERT INTO coll_test (id, s) values (1, '﻿xぁx');
INSERT INTO coll_test (id, s) values (2, 'xィーx');
INSERT INTO coll_test (id, s) values (4, 'xォーx');
INSERT INTO coll_test (id, s) values (3, 'xぇ');

SELECT id, s FROM coll_test ORDER BY s;

SELECT id, s FROM coll_test WHERE s LIKE 'xぁ%' ORDER BY 2;

SELECT id, s FROM coll_test WHERE s > 'xぁ' ORDER BY 2;

SELECT id, s FROM coll_test WHERE s LIKE 'xぇ%' ORDER BY 2;

SELECT id, s FROM coll_test WHERE s > 'xぇ' ORDER BY 2;

DROP TABLE coll_test;
set names iso88591;
commit;
--+ holdcas off;