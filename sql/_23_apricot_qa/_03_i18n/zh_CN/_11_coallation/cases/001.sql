--+ holdcas on;
set names utf8;
CREATE TABLE t(
col1 INT NOT NULL AUTO_INCREMENT, 
col2 CHAR collate utf8_gen DEFAULT NULL, 
col3 VARCHAR(32) collate utf8_gen DEFAULT NULL, 
col4 STRING collate utf8_gen DEFAULT NULL
);

INSERT INTO t(col2, col3, col4) VALUES('a', 'a', CONCAT(' ', 'a'));
INSERT INTO t(col2, col3, col4) VALUES('b', 'b', CONCAT(' ', 'b'));
INSERT INTO t(col2, col3, col4) VALUES('c', 'c', CONCAT(' ', 'c'));
INSERT INTO t(col2, col3, col4) VALUES('v', 'v', CONCAT(' ', 'v'));
INSERT INTO t(col2, col3, col4) VALUES('y', 'y', CONCAT(' ', 'y'));
INSERT INTO t(col2, col3, col4) VALUES('z', 'z', CONCAT(' ', 'z'));
-- TR chars
INSERT INTO t(col2, col3, col4) VALUES('ç', 'ç', CONCAT(' ', 'ç'));
INSERT INTO t(col2, col3, col4) VALUES('ğ', 'ğ', CONCAT(' ', 'ğ'));
INSERT INTO t(col2, col3, col4) VALUES('ı', 'ı', CONCAT(' ', 'ı'));
INSERT INTO t(col2, col3, col4) VALUES('i', 'i', CONCAT(' ', 'i'));
INSERT INTO t(col2, col3, col4) VALUES('ö', 'ö', CONCAT(' ', 'ö'));
INSERT INTO t(col2, col3, col4) VALUES('ş', 'ş', CONCAT(' ', 'ş'));
INSERT INTO t(col2, col3, col4) VALUES('ü', 'ü', CONCAT(' ', 'ü'));
-- CN chars
INSERT INTO t(col2, col3, col4) VALUES('ē', 'ē', CONCAT(' ', 'ē'));
INSERT INTO t(col2, col3, col4) VALUES('ǎ', 'ǎ', CONCAT(' ', 'ǎ'));
INSERT INTO t(col2, col3, col4) VALUES('Ā', 'Ā', CONCAT(' ', 'Ā'));
INSERT INTO t(col2, col3, col4) VALUES('Ń', 'Ń', CONCAT(' ', 'Ń'));
INSERT INTO t(col2, col3, col4) VALUES('ǖ', 'ǖ', CONCAT(' ', 'ǖ'));
INSERT INTO t(col2, col3, col4) VALUES('Ǘ', 'Ǘ', CONCAT(' ', 'Ǘ'));
INSERT INTO t(col2, col3, col4) VALUES('1', '1', CONCAT(' ', '1'));
INSERT INTO t(col2, col3, col4) VALUES('0', '0', CONCAT(' ', '0'));
INSERT INTO t(col2, col3, col4) VALUES('9', '9', CONCAT(' ', '9'));
INSERT INTO t(col2, col3, col4) VALUES('阿', '阿', CONCAT(' ', '阿'));
INSERT INTO t(col2, col3, col4) VALUES('呵', '呵', CONCAT(' ', '呵'));
INSERT INTO t(col2, col3, col4) VALUES('爸', '爸', CONCAT(' ', '爸'));
INSERT INTO t(col2, col3, col4) VALUES('一', '一', CONCAT(' ', '一'));
INSERT INTO t(col2, col3, col4) VALUES('七', '七', CONCAT(' ', '七'));
INSERT INTO t(col2, col3, col4) VALUES('再', '再', CONCAT(' ', '再'));
INSERT INTO t(col2, col3, col4) VALUES('帀', '帀', CONCAT(' ', '帀'));



-- UPPER
-- Latin chars
INSERT INTO t(col2, col3, col4) VALUES(UPPER('a'), UPPER('a'), CONCAT(' ', UPPER('a')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('b'), UPPER('b'), CONCAT(' ', UPPER('b')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('c'), UPPER('c'), CONCAT(' ', UPPER('c')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('v'), UPPER('v'), CONCAT(' ', UPPER('v')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('y'), UPPER('y'), CONCAT(' ', UPPER('y')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('z'), UPPER('z'), CONCAT(' ', UPPER('z')));
-- TR chars
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ç'), UPPER('ç'), CONCAT(' ', UPPER('ç')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ğ'), UPPER('ğ'), CONCAT(' ', UPPER('ğ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ı'), UPPER('ı'), CONCAT(' ', UPPER('ı')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('i'), UPPER('i'), CONCAT(' ', UPPER('i')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ö'), UPPER('ö'), CONCAT(' ', UPPER('ö')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ş'), UPPER('ş'), CONCAT(' ', UPPER('ş')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ü'), UPPER('ü'), CONCAT(' ', UPPER('ü')));
-- CN chars
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ē'), UPPER('ē'), CONCAT(' ', UPPER('ē')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ǎ'), UPPER('ǎ'), CONCAT(' ', UPPER('ǎ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('Ā'), UPPER('Ā'), CONCAT(' ', UPPER('Ā')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('Ń'), UPPER('Ń'), CONCAT(' ', UPPER('Ń')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ǖ'), UPPER('ǖ'), CONCAT(' ', UPPER('ǖ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('Ǘ'), UPPER('Ǘ'), CONCAT(' ', UPPER('Ǘ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('1'), UPPER('1'), CONCAT(' ', UPPER('1')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('0'), UPPER('0'), CONCAT(' ', UPPER('0')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('9'), UPPER('9'), CONCAT(' ', UPPER('9')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('阿'), UPPER('阿'), CONCAT(' ', UPPER('阿')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('呵'), UPPER('呵'), CONCAT(' ', UPPER('呵')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('爸'), UPPER('爸'), CONCAT(' ', UPPER('爸')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('一'), UPPER('一'), CONCAT(' ', UPPER('一')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('七'), UPPER('七'), CONCAT(' ', UPPER('七')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('再'), UPPER('再'), CONCAT(' ', UPPER('再')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('帀'), UPPER('帀'), CONCAT(' ', UPPER('帀')));
--test
SELECT * from t order by col2,col1;
--test
SELECT * from t order by col3 DESC,col1;
--test
SELECT * from t order by col4,col1;

DROP TABLE t;
set names iso88591;
commit;
--+ holdcas off;