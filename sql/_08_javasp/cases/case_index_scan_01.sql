CREATE OR REPLACE FUNCTION intTest(x int) RETURN int AS LANGUAGE JAVA NAME 'SpTest7.typetestint(int) return int';
CREATE OR REPLACE FUNCTION stringTest(x String) RETURN String AS LANGUAGE JAVA NAME 'SpTest7.typeteststring(java.lang.String) return java.lang.String';

DROP IF EXISTS tbl;

CREATE TABLE tbl (ord INT, col_int INT, col_char char(1));
CREATE INDEX i_tbl ON tbl (ord);
CREATE INDEX i_tbl_char ON tbl (col_char);

INSERT INTO tbl VALUES (1,10,'a');
INSERT INTO tbl VALUES (2,10,'b');
INSERT INTO tbl VALUES (3,10,'c');
INSERT INTO tbl VALUES (4,10,'d');
INSERT INTO tbl VALUES (5,10,'e');
INSERT INTO tbl VALUES (6,10,'f');
INSERT INTO tbl VALUES (7,10,'g');
INSERT INTO tbl VALUES (8,10,'h');
INSERT INTO tbl VALUES (9,10,'i');
INSERT INTO tbl VALUES (10,10,'j');

-- equal
SELECT count(*) AS "equal" FROM tbl WHERE ord = (SELECT inttest(5) FROM dual);
SELECT count(*) AS "equal" FROM tbl WHERE ord = (SELECT inttest(ord) FROM tbl where ord=5);

-- in
SELECT count(*) AS "in" FROM tbl WHERE ord IN (SELECT inttest(5) FROM dual);
SELECT count(*) AS "in" FROM tbl WHERE ord IN (SELECT inttest(ord) FROM tbl);

-- LIKE
SELECT count(*) AS "like" FROM tbl WHERE col_char LIKE (SELECT stringTest('a') FROM dual);
-- (Related CBRD-24686) can not index-scan the 'JAVASP' function on 'LIKE' clause.
SELECT count(*) AS "like" FROM tbl WHERE col_char LIKE (SELECT stringTest(col_char) FROM tbl where ord=5);

DROP FUNCTION inttest, stringTest;

DROP tbl;

