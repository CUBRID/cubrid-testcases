--+ holdcas on;
set names utf8;
CREATE TABLE t(
col1 INT NOT NULL AUTO_INCREMENT, 
col2 CHAR collate utf8_ja_exp DEFAULT NULL, 
col3 VARCHAR(32) utf8_ja_exp DEFAULT NULL, 
col4 STRING utf8_ja_exp DEFAULT NULL
);

INSERT INTO t(col2, col3, col4) VALUES('ぁ', 'ぁ', CONCAT(' ', 'ぁ'));
INSERT INTO t(col2, col3, col4) VALUES('ぃ', 'ぃ', CONCAT(' ', 'ぃ'));
INSERT INTO t(col2, col3, col4) VALUES('ぇ', 'ぇ', CONCAT(' ', 'ぇ'));
INSERT INTO t(col2, col3, col4) VALUES('ぉ', 'ぉ', CONCAT(' ', 'ぉ'));
INSERT INTO t(col2, col3, col4) VALUES('ゃ', 'ゃ', CONCAT(' ', 'ゃ'));
INSERT INTO t(col2, col3, col4) VALUES('ん', 'ん', CONCAT(' ', 'ん'));
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
INSERT INTO t(col2, col3, col4) VALUES('語', '語', CONCAT(' ', '語'));
INSERT INTO t(col2, col3, col4) VALUES('1', '1', CONCAT(' ', '1'));
INSERT INTO t(col2, col3, col4) VALUES('亜', '亜', CONCAT(' ', '亜'));
INSERT INTO t(col2, col3, col4) VALUES('■', '■', CONCAT(' ', '■'));
INSERT INTO t(col2, col3, col4) VALUES('○', '○', CONCAT(' ', '○'));
INSERT INTO t(col2, col3, col4) VALUES('韓', '韓', CONCAT(' ', '韓'));
INSERT INTO t(col2, col3, col4) VALUES('帀', '帀', CONCAT(' ', '帀'));



-- UPPER
-- Latin chars
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ぁ'), UPPER('ぁ'), CONCAT(' ', UPPER('ぁ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ぃ'), UPPER('ぃ'), CONCAT(' ', UPPER('ぃ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ぇ'), UPPER('ぇ'), CONCAT(' ', UPPER('ぇ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ぉ'), UPPER('ぉ'), CONCAT(' ', UPPER('ぉ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ゃ'), UPPER('ゃ'), CONCAT(' ', UPPER('ゃ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ん'), UPPER('ん'), CONCAT(' ', UPPER('ん')));
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
INSERT INTO t(col2, col3, col4) VALUES(UPPER('語'), UPPER('語'), CONCAT(' ', UPPER('語')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('1'), UPPER('1'), CONCAT(' ', UPPER('1')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('亜'), UPPER('亜'), CONCAT(' ', UPPER('亜')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('■'), UPPER('■'), CONCAT(' ', UPPER('■')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('○'), UPPER('○'), CONCAT(' ', UPPER('○')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('韓'), UPPER('韓'), CONCAT(' ', UPPER('韓')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('帀'), UPPER('帀'), CONCAT(' ', UPPER('帀')));
--test
SELECT * from t order by col2;
--test
SELECT * from t order by col3 DESC;
--test
SELECT * from t order by col4;

DROP TABLE t;
set names iso88591;
commit;
--+ holdcas off;