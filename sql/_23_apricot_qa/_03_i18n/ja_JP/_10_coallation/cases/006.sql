--+ holdcas on;
set names utf8;
CREATE TABLE t(
col1 INT NOT NULL AUTO_INCREMENT, 
col2 CHAR collate utf8_ja_exp DEFAULT NULL 
);

INSERT INTO t(col2) VALUES('ぁ');
INSERT INTO t(col2) VALUES('ぃ');
INSERT INTO t(col2) VALUES('ぇ');
INSERT INTO t(col2) VALUES('ぉ');
INSERT INTO t(col2) VALUES('ゃ');
INSERT INTO t(col2) VALUES('ん');
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
INSERT INTO t(col2) VALUES('語');
INSERT INTO t(col2) VALUES('1');
INSERT INTO t(col2) VALUES('亜');
INSERT INTO t(col2) VALUES('■');
INSERT INTO t(col2) VALUES('○');
INSERT INTO t(col2) VALUES('韓');
INSERT INTO t(col2) VALUES('帀');



-- UPPER
-- Latin chars
INSERT INTO t(col2) VALUES(UPPER('ぁ'));
INSERT INTO t(col2) VALUES(UPPER('ぃ'));
INSERT INTO t(col2) VALUES(UPPER('ぇ'));
INSERT INTO t(col2) VALUES(UPPER('ぉ'));
INSERT INTO t(col2) VALUES(UPPER('ゃ'));
INSERT INTO t(col2) VALUES(UPPER('ん'));
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
INSERT INTO t(col2) VALUES(UPPER('語'));
INSERT INTO t(col2) VALUES(UPPER('1'));
INSERT INTO t(col2) VALUES(UPPER('亜'));
INSERT INTO t(col2) VALUES(UPPER('■'));
INSERT INTO t(col2) VALUES(UPPER('○'));
INSERT INTO t(col2) VALUES(UPPER('韓'));
INSERT INTO t(col2) VALUES(UPPER('帀'));

--test
SELECT * from t  where col2 between UPPER('帀') and 'ü' order by col2,col1;
--test
SELECT * from t  where col2 between UPPER('帀') and '9' order by col2 desc,col1;
--test
SELECT * from t  where col2 between UPPER('■') and '語' order by col2,col1 limit 3;
--test
SELECT * from t  where col2 between UPPER('ē') and 'ü' order by col2 desc,col1 limit 2;

INSERT INTO t(col2) VALUES('l');
INSERT INTO t(col2) VALUES('8');
INSERT INTO t(col2) VALUES('发');
INSERT INTO t(col2) VALUES('五');

--test
SELECT * from t  where col2 between UPPER('韓') and '■' order by col2,col1;
--test
SELECT * from t  where col2 between UPPER('韓') and 'ü' order by col2 desc,col1;
--test
SELECT * from t  where col2 between UPPER('9') and 'ぁ' order by col2,col1 limit 3;
--test
SELECT * from t  where col2 between UPPER('ぃ') and '帀' order by col2 desc,col1 limit 2;

update t set col2='你' where col2='ç';
--test
SELECT * from t  where col2 between UPPER('韓') and '■' order by col2,col1;
--test
SELECT * from t  where col2 between UPPER('韓') and 'ü' order by col2 desc,col1;
--test
SELECT * from t  where col2 between UPPER('9') and 'ぁ' order by col2,col1 limit 3;
--test
SELECT * from t  where col2 between UPPER('ぃ') and '帀' order by col2 desc,col1 limit 2;
delete from t where col2 ='ü';
--test
SELECT * from t  where col2 between UPPER('韓') and '■'order by col2,col1;
--test                              
SELECT * from t  where col2 between UPPER('韓') and 'ü' order by col2 desc,col1;
--test                              
SELECT * from t  where col2 between UPPER('9') and 'ぁ'  order by col2,col1 limit 3;
--test                              
SELECT * from t  where col2 between UPPER('ぃ') and '帀' order by col2 desc,col1 limit 2;

DROP TABLE t;
set names iso88591;
commit;
--+ holdcas off;