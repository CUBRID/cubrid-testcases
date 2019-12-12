--+ holdcas on;
set names utf8;
CREATE TABLE t(
col1 INT NOT NULL AUTO_INCREMENT, 
col2 CHAR collate utf8_gen DEFAULT NULL 
);

INSERT INTO t(col2) VALUES('a');
INSERT INTO t(col2) VALUES('b');
INSERT INTO t(col2) VALUES('c');
INSERT INTO t(col2) VALUES('v');
INSERT INTO t(col2) VALUES('y');
INSERT INTO t(col2) VALUES('z');
-- TR chars
INSERT INTO t(col2) VALUES('ç');
INSERT INTO t(col2) VALUES('ğ');
INSERT INTO t(col2) VALUES('ı');
INSERT INTO t(col2) VALUES('i');
INSERT INTO t(col2) VALUES('ö');
INSERT INTO t(col2) VALUES('ş');
INSERT INTO t(col2) VALUES('ü');
-- CN chars
INSERT INTO t(col2) VALUES('ē');
INSERT INTO t(col2) VALUES('ǎ');
INSERT INTO t(col2) VALUES('Ā');
INSERT INTO t(col2) VALUES('Ń');
INSERT INTO t(col2) VALUES('ǖ');
INSERT INTO t(col2) VALUES('Ǘ');
INSERT INTO t(col2) VALUES('1');
INSERT INTO t(col2) VALUES('0');
INSERT INTO t(col2) VALUES('9');
INSERT INTO t(col2) VALUES('阿');
INSERT INTO t(col2) VALUES('呵');
INSERT INTO t(col2) VALUES('爸');
INSERT INTO t(col2) VALUES('一');
INSERT INTO t(col2) VALUES('七');
INSERT INTO t(col2) VALUES('再');
INSERT INTO t(col2) VALUES('帀');



-- UPPER
-- Latin chars
INSERT INTO t(col2) VALUES(UPPER('a'));
INSERT INTO t(col2) VALUES(UPPER('b'));
INSERT INTO t(col2) VALUES(UPPER('c'));
INSERT INTO t(col2) VALUES(UPPER('v'));
INSERT INTO t(col2) VALUES(UPPER('y'));
INSERT INTO t(col2) VALUES(UPPER('z'));
-- TR chars
INSERT INTO t(col2) VALUES(UPPER('ç'));
INSERT INTO t(col2) VALUES(UPPER('ğ'));
INSERT INTO t(col2) VALUES(UPPER('ı'));
INSERT INTO t(col2) VALUES(UPPER('i'));
INSERT INTO t(col2) VALUES(UPPER('ö'));
INSERT INTO t(col2) VALUES(UPPER('ş'));
INSERT INTO t(col2) VALUES(UPPER('ü'));
-- CN chars
INSERT INTO t(col2) VALUES(UPPER('ē'));
INSERT INTO t(col2) VALUES(UPPER('ǎ'));
INSERT INTO t(col2) VALUES(UPPER('Ā'));
INSERT INTO t(col2) VALUES(UPPER('Ń'));
INSERT INTO t(col2) VALUES(UPPER('ǖ'));
INSERT INTO t(col2) VALUES(UPPER('Ü'));
INSERT INTO t(col2) VALUES(UPPER('Ǘ'));
INSERT INTO t(col2) VALUES(UPPER('1'));
INSERT INTO t(col2) VALUES(UPPER('0'));
INSERT INTO t(col2) VALUES(UPPER('9'));
INSERT INTO t(col2) VALUES(UPPER('阿'));
INSERT INTO t(col2) VALUES(UPPER('呵'));
INSERT INTO t(col2) VALUES(UPPER('爸'));
INSERT INTO t(col2) VALUES(UPPER('一'));
INSERT INTO t(col2) VALUES(UPPER('七'));
INSERT INTO t(col2) VALUES(UPPER('再'));
INSERT INTO t(col2) VALUES(UPPER('帀'));
--test
SELECT * from t  where col2 between UPPER('Ǘ') and 'ü' order by col2, col1;
--test
SELECT * from t  where col2 between UPPER('n') and 'Ü' order by col2 desc, col1;
--test
SELECT * from t  where col2 between UPPER('阿') and '帀' order by col2, col1 limit 3;
--test
SELECT * from t  where col2 between UPPER('ē') and '帀' order by col2 desc, col1 limit 2;
DROP TABLE t;
set names iso88591;
commit;
--+ holdcas off;