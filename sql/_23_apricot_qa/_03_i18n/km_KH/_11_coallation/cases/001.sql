--+ holdcas on;
set names utf8;
drop table if exists t;
CREATE TABLE t(
col1 INT NOT NULL AUTO_INCREMENT, 
col2 CHAR(5) collate utf8_km_exp DEFAULT NULL, 
col3 VARCHAR(32) collate utf8_km_exp DEFAULT NULL, 
col4 STRING collate utf8_km_exp DEFAULT NULL
);

INSERT INTO t(col2, col3, col4) VALUES('ក', 'ក', CONCAT(' ', 'ក'));
INSERT INTO t(col2, col3, col4) VALUES('ខ', 'ខ', CONCAT(' ', 'ខ'));
INSERT INTO t(col2, col3, col4) VALUES('គ', 'គ', CONCAT(' ', 'គ'));
INSERT INTO t(col2, col3, col4) VALUES('ឃ', 'ឃ', CONCAT(' ', 'ឃ'));
INSERT INTO t(col2, col3, col4) VALUES('ង', 'ង', CONCAT(' ', 'ង'));
INSERT INTO t(col2, col3, col4) VALUES('ច', 'ច', CONCAT(' ', 'ច'));
INSERT INTO t(col2, col3, col4) VALUES('ញ', 'ញ', CONCAT(' ', 'ញ'));
INSERT INTO t(col2, col3, col4) VALUES('ដ', 'ដ', CONCAT(' ', 'ដ'));
INSERT INTO t(col2, col3, col4) VALUES('ណ', 'ណ', CONCAT(' ', 'ណ'));
INSERT INTO t(col2, col3, col4) VALUES('ត', 'ត', CONCAT(' ', 'ត'));
INSERT INTO t(col2, col3, col4) VALUES('ន', 'ន', CONCAT(' ', 'ន'));
INSERT INTO t(col2, col3, col4) VALUES('ប', 'ប', CONCAT(' ', 'ប'));
INSERT INTO t(col2, col3, col4) VALUES('ម', 'ម', CONCAT(' ', 'ម'));
INSERT INTO t(col2, col3, col4) VALUES('យ', 'យ', CONCAT(' ', 'យ'));
INSERT INTO t(col2, col3, col4) VALUES('ឝ', 'ឝ', CONCAT(' ', 'ឝ'));
INSERT INTO t(col2, col3, col4) VALUES('ឞ', 'ឞ', CONCAT(' ', 'ឞ'));
INSERT INTO t(col2, col3, col4) VALUES('អ', 'អ', CONCAT(' ', 'អ'));
INSERT INTO t(col2, col3, col4) VALUES('ហ្គ', 'ហ្គ', CONCAT(' ', 'ហ្គ'));
INSERT INTO t(col2, col3, col4) VALUES('ហ្ម', 'ហ្ម', CONCAT(' ', 'ហ្ម'));
--0~9
INSERT INTO t(col2, col3, col4) VALUES('០', '០', CONCAT(' ', '០'));
INSERT INTO t(col2, col3, col4) VALUES('១', '១', CONCAT(' ', '១'));
INSERT INTO t(col2, col3, col4) VALUES('២', '២', CONCAT(' ', '២'));
INSERT INTO t(col2, col3, col4) VALUES('៣', '៣', CONCAT(' ', '៣'));
INSERT INTO t(col2, col3, col4) VALUES('៤', '៤', CONCAT(' ', '៤'));
INSERT INTO t(col2, col3, col4) VALUES('៥', '៥', CONCAT(' ', '៥'));
INSERT INTO t(col2, col3, col4) VALUES('៦', '៦', CONCAT(' ', '៦'));
INSERT INTO t(col2, col3, col4) VALUES('៧', '៧', CONCAT(' ', '៧'));
INSERT INTO t(col2, col3, col4) VALUES('៨', '៨', CONCAT(' ', '៨'));
INSERT INTO t(col2, col3, col4) VALUES('៩', '៩', CONCAT(' ', '៩'));





INSERT INTO t(col2, col3, col4) VALUES(UPPER('ក'), UPPER('ក'), CONCAT(' ', UPPER('ក')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ខ'), UPPER('ខ'), CONCAT(' ', UPPER('ខ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('គ'), UPPER('គ'), CONCAT(' ', UPPER('គ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ឃ'), UPPER('ឃ'), CONCAT(' ', UPPER('ឃ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ង'), UPPER('ង'), CONCAT(' ', UPPER('ង')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ច'), UPPER('ច'), CONCAT(' ', UPPER('ច')));

INSERT INTO t(col2, col3, col4) VALUES(UPPER('ញ'), UPPER('ញ'), CONCAT(' ', UPPER('ញ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ដ'), UPPER('ដ'), CONCAT(' ', UPPER('ដ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ណ'), UPPER('ណ'), CONCAT(' ', UPPER('ណ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ត'), UPPER('ត'), CONCAT(' ', UPPER('ត')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ន'), UPPER('ន'), CONCAT(' ', UPPER('ន')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ប'), UPPER('ប'), CONCAT(' ', UPPER('ប')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ម'), UPPER('ម'), CONCAT(' ', UPPER('ម')));

INSERT INTO t(col2, col3, col4) VALUES(UPPER('យ'), UPPER('យ'), CONCAT(' ', UPPER('យ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ឝ'), UPPER('ឝ'), CONCAT(' ', UPPER('ឝ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ឞ'), UPPER('ឞ'), CONCAT(' ', UPPER('ឞ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('អ'), UPPER('អ'), CONCAT(' ', UPPER('អ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ហ្គ'), UPPER('ហ្គ'), CONCAT(' ', UPPER('ហ្គ')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('ហ្ម'), UPPER('ហ្ម'), CONCAT(' ', UPPER('ហ្ម')));
--0~9
INSERT INTO t(col2, col3, col4) VALUES(UPPER('០'), UPPER('០'), CONCAT(' ', UPPER('០')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('១'), UPPER('១'), CONCAT(' ', UPPER('១')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('២'), UPPER('២'), CONCAT(' ', UPPER('២')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('៣'), UPPER('៣'), CONCAT(' ', UPPER('៣')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('៤'), UPPER('៤'), CONCAT(' ', UPPER('៤')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('៥'), UPPER('៥'), CONCAT(' ', UPPER('៥')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('៦'), UPPER('៦'), CONCAT(' ', UPPER('៦')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('៧'), UPPER('៧'), CONCAT(' ', UPPER('៧')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('៨'), UPPER('៨'), CONCAT(' ', UPPER('៨')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('៩'), UPPER('៩'), CONCAT(' ', UPPER('៩')));
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
