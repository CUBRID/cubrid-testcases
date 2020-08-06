--+ holdcas on;
set names utf8;
drop table if exists t;
CREATE TABLE t(
col1 INT NOT NULL AUTO_INCREMENT, 
col2 CHAR(5) collate utf8_km_exp DEFAULT NULL 
);

INSERT INTO t(col2) VALUES('ក');
INSERT INTO t(col2) VALUES('ខ');
INSERT INTO t(col2) VALUES('គ');
INSERT INTO t(col2) VALUES('ឃ');
INSERT INTO t(col2) VALUES('ង');
INSERT INTO t(col2) VALUES('ច');

INSERT INTO t(col2) VALUES('ញ');
INSERT INTO t(col2) VALUES('ដ');
INSERT INTO t(col2) VALUES('ណ');
INSERT INTO t(col2) VALUES('ត');
INSERT INTO t(col2) VALUES('ន');
INSERT INTO t(col2) VALUES('ប');
INSERT INTO t(col2) VALUES('ម');

INSERT INTO t(col2) VALUES('យ');
INSERT INTO t(col2) VALUES('ឝ');
INSERT INTO t(col2) VALUES('ឞ');
INSERT INTO t(col2) VALUES('អ');
INSERT INTO t(col2) VALUES('ហ្គ');
INSERT INTO t(col2) VALUES('ហ្ម');
INSERT INTO t(col2) VALUES('០');
INSERT INTO t(col2) VALUES('១');
INSERT INTO t(col2) VALUES('២');
INSERT INTO t(col2) VALUES('៣');
INSERT INTO t(col2) VALUES('៤');
INSERT INTO t(col2) VALUES('៥');
INSERT INTO t(col2) VALUES('៦');
INSERT INTO t(col2) VALUES('៧');
INSERT INTO t(col2) VALUES('៨');
INSERT INTO t(col2) VALUES('៩');





INSERT INTO t(col2) VALUES(UPPER('ក'));
INSERT INTO t(col2) VALUES(UPPER('ខ'));
INSERT INTO t(col2) VALUES(UPPER('គ'));
INSERT INTO t(col2) VALUES(UPPER('ឃ'));
INSERT INTO t(col2) VALUES(UPPER('ង'));
INSERT INTO t(col2) VALUES(UPPER('ច'));

INSERT INTO t(col2) VALUES(UPPER('ញ'));
INSERT INTO t(col2) VALUES(UPPER('ដ'));
INSERT INTO t(col2) VALUES(UPPER('ណ'));
INSERT INTO t(col2) VALUES(UPPER('ត'));
INSERT INTO t(col2) VALUES(UPPER('ន'));
INSERT INTO t(col2) VALUES(UPPER('ប'));
INSERT INTO t(col2) VALUES(UPPER('ម'));

INSERT INTO t(col2) VALUES(UPPER('យ'));
INSERT INTO t(col2) VALUES(UPPER('ឝ'));
INSERT INTO t(col2) VALUES(UPPER('ឞ'));
INSERT INTO t(col2) VALUES(UPPER('អ'));
INSERT INTO t(col2) VALUES(UPPER('ហ្គ'));
INSERT INTO t(col2) VALUES(UPPER('ម'));
INSERT INTO t(col2) VALUES(UPPER('ហ្ម'));
INSERT INTO t(col2) VALUES(UPPER('០'));
INSERT INTO t(col2) VALUES(UPPER('១'));
INSERT INTO t(col2) VALUES(UPPER('២'));
INSERT INTO t(col2) VALUES(UPPER('៣'));
INSERT INTO t(col2) VALUES(UPPER('៤'));
INSERT INTO t(col2) VALUES(UPPER('៥'));
INSERT INTO t(col2) VALUES(UPPER('៦'));
INSERT INTO t(col2) VALUES(UPPER('៧'));
INSERT INTO t(col2) VALUES(UPPER('៨'));
INSERT INTO t(col2) VALUES(UPPER('៩'));

--test
SELECT * from t  where col2 between UPPER('៩') and 'ម' order by col2,col1;
--test
SELECT * from t  where col2 between UPPER('៩') and '២' order by col2 desc,col1;
--test
SELECT * from t  where col2 between UPPER('៦') and '៣' order by col2 ,col1 limit 3;
--test
SELECT * from t  where col2 between UPPER('យ') and 'ម' order by col2 desc,col1  limit 2;

INSERT INTO t(col2) VALUES('l');
INSERT INTO t(col2) VALUES('8');
INSERT INTO t(col2) VALUES('发');
INSERT INTO t(col2) VALUES('五');

--test
SELECT * from t  where col2 between UPPER('៨') and '៦' order by col2,col1;
--test
SELECT * from t  where col2 between UPPER('៨') and 'ម' order by col2 desc,col1;
--test
SELECT * from t  where col2 between UPPER('២') and 'ក' order by col2 ,col1 limit 3;
--test
SELECT * from t  where col2 between UPPER('ខ') and '៩' order by col2 desc,col1  limit 2;

update t set col2='你' where col2='ញ';
--test
SELECT * from t  where col2 between UPPER('៨') and '៦' order by col2,col1 ;
--test
SELECT * from t  where col2 between UPPER('៨') and 'ម' order by col2 desc,col1 ;
--test
SELECT * from t  where col2 between UPPER('២') and 'ក' order by col2 ,col1 limit 3;
--test
SELECT * from t  where col2 between UPPER('ខ') and '៩' order by col2 desc,col1  limit 2;
delete from t where col2 ='ម';
--test
SELECT * from t  where col2 between UPPER('៨') and '៦'order by col2,col1 ;
--test                              
SELECT * from t  where col2 between UPPER('៨') and 'ម' order by col2 desc,col1;
--test                              
SELECT * from t  where col2 between UPPER('២') and 'ក'  order by col2 ,col1 limit 3;
--test                              
SELECT * from t  where col2 between UPPER('ខ') and '៩' order by col2 desc ,col1 limit 2;

DROP TABLE t;
set names iso88591;
commit;
--+ holdcas off;
