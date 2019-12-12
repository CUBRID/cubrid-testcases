--+ holdcas on;
set names utf8;
CREATE TABLE t(
col1 INT NOT NULL AUTO_INCREMENT, 
col2 CHAR  collate utf8_tr_cs DEFAULT NULL 
);

INSERT INTO t(col2) VALUES('a');
INSERT INTO t(col2) VALUES('b');
INSERT INTO t(col2) VALUES('c');
INSERT INTO t(col2) VALUES('d');
INSERT INTO t(col2) VALUES('e');
INSERT INTO t(col2) VALUES('f');
INSERT INTO t(col2) VALUES('g');
INSERT INTO t(col2) VALUES('h');
INSERT INTO t(col2) VALUES('j');
INSERT INTO t(col2) VALUES('k');
-- TR chars
INSERT INTO t(col2) VALUES('ç');
INSERT INTO t(col2) VALUES('ğ');
INSERT INTO t(col2) VALUES('ı');
INSERT INTO t(col2) VALUES('i');
INSERT INTO t(col2) VALUES('ö');
INSERT INTO t(col2) VALUES('ş');
INSERT INTO t(col2) VALUES('ü');
-- Non TR chars
INSERT INTO t(col2) VALUES('q');
INSERT INTO t(col2) VALUES('x');
INSERT INTO t(col2) VALUES('w');

-- UPPER
-- Latin chars
INSERT INTO t(col2) VALUES(UPPER('a'));
INSERT INTO t(col2) VALUES(UPPER('b'));
INSERT INTO t(col2) VALUES(UPPER('c'));
INSERT INTO t(col2) VALUES(UPPER('d'));
INSERT INTO t(col2) VALUES(UPPER('e'));
INSERT INTO t(col2) VALUES(UPPER('f'));
INSERT INTO t(col2) VALUES(UPPER('g'));
INSERT INTO t(col2) VALUES(UPPER('h'));
INSERT INTO t(col2) VALUES(UPPER('j'));
INSERT INTO t(col2) VALUES(UPPER('k'));
INSERT INTO t(col2) VALUES(UPPER('l'));
INSERT INTO t(col2) VALUES(UPPER('m'));
INSERT INTO t(col2) VALUES(UPPER('n'));
INSERT INTO t(col2) VALUES(UPPER('o'));

--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 desc;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 limit 3;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 desc limit 2;

INSERT INTO t(col2) VALUES('l');
INSERT INTO t(col2) VALUES('m');
INSERT INTO t(col2) VALUES('n');
INSERT INTO t(col2) VALUES('o');
INSERT INTO t(col2) VALUES('p');
INSERT INTO t(col2) VALUES('r');
INSERT INTO t(col2) VALUES('s');
INSERT INTO t(col2) VALUES('t');
INSERT INTO t(col2) VALUES('u');
INSERT INTO t(col2) VALUES('v');
INSERT INTO t(col2) VALUES('y');
INSERT INTO t(col2) VALUES('z');
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 desc;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 limit 3;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 desc limit 2;

update t set col2='你' where col2='ç';
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 desc;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 limit 3;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 desc limit 2;
delete from t where col2 ='ü';
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 desc;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 limit 3;
--test
SELECT * from t  where col2 between UPPER('ç') and 'ü' order by col2 desc limit 2;

DROP TABLE t;
set names iso88591;
commit;
--+ holdcas off;