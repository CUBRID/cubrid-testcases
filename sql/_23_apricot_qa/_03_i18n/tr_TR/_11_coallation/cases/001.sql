--+ holdcas on;
set names utf8;
CREATE TABLE t(
col1 INT NOT NULL AUTO_INCREMENT, 
col2 CHAR  collate utf8_tr_cs DEFAULT NULL, 
col3 VARCHAR(32) collate utf8_tr_cs DEFAULT NULL, 
col4 STRING collate utf8_tr_cs DEFAULT NULL
);

INSERT INTO t(col2, col3, col4) VALUES('a', 'a', CONCAT(' ', 'a'));
INSERT INTO t(col2, col3, col4) VALUES('b', 'b', CONCAT(' ', 'b'));
INSERT INTO t(col2, col3, col4) VALUES('c', 'c', CONCAT(' ', 'c'));
INSERT INTO t(col2, col3, col4) VALUES('d', 'd', CONCAT(' ', 'd'));
INSERT INTO t(col2, col3, col4) VALUES('e', 'e', CONCAT(' ', 'e'));
INSERT INTO t(col2, col3, col4) VALUES('f', 'f', CONCAT(' ', 'f'));
INSERT INTO t(col2, col3, col4) VALUES('g', 'g', CONCAT(' ', 'g'));
INSERT INTO t(col2, col3, col4) VALUES('h', 'h', CONCAT(' ', 'h'));
INSERT INTO t(col2, col3, col4) VALUES('j', 'j', CONCAT(' ', 'j'));
INSERT INTO t(col2, col3, col4) VALUES('k', 'k', CONCAT(' ', 'k'));
INSERT INTO t(col2, col3, col4) VALUES('l', 'l', CONCAT(' ', 'l'));
INSERT INTO t(col2, col3, col4) VALUES('m', 'm', CONCAT(' ', 'm'));
INSERT INTO t(col2, col3, col4) VALUES('n', 'n', CONCAT(' ', 'n'));
INSERT INTO t(col2, col3, col4) VALUES('o', 'o', CONCAT(' ', 'o'));
INSERT INTO t(col2, col3, col4) VALUES('p', 'p', CONCAT(' ', 'p'));
INSERT INTO t(col2, col3, col4) VALUES('r', 'r', CONCAT(' ', 'r'));
INSERT INTO t(col2, col3, col4) VALUES('s', 's', CONCAT(' ', 's'));
INSERT INTO t(col2, col3, col4) VALUES('t', 't', CONCAT(' ', 't'));
INSERT INTO t(col2, col3, col4) VALUES('u', 'u', CONCAT(' ', 'u'));
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
-- Non TR chars
INSERT INTO t(col2, col3, col4) VALUES('q', 'q', CONCAT(' ', 'q'));
INSERT INTO t(col2, col3, col4) VALUES('x', 'x', CONCAT(' ', 'x'));
INSERT INTO t(col2, col3, col4) VALUES('w', 'w', CONCAT(' ', 'w'));

-- UPPER
-- Latin chars
INSERT INTO t(col2, col3, col4) VALUES(UPPER('a'), UPPER('a'), CONCAT(' ', UPPER('a')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('b'), UPPER('b'), CONCAT(' ', UPPER('b')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('c'), UPPER('c'), CONCAT(' ', UPPER('c')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('d'), UPPER('d'), CONCAT(' ', UPPER('d')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('e'), UPPER('e'), CONCAT(' ', UPPER('e')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('f'), UPPER('f'), CONCAT(' ', UPPER('f')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('g'), UPPER('g'), CONCAT(' ', UPPER('g')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('h'), UPPER('h'), CONCAT(' ', UPPER('h')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('j'), UPPER('j'), CONCAT(' ', UPPER('j')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('k'), UPPER('k'), CONCAT(' ', UPPER('k')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('l'), UPPER('l'), CONCAT(' ', UPPER('l')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('m'), UPPER('m'), CONCAT(' ', UPPER('m')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('n'), UPPER('n'), CONCAT(' ', UPPER('n')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('o'), UPPER('o'), CONCAT(' ', UPPER('o')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('p'), UPPER('p'), CONCAT(' ', UPPER('p')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('r'), UPPER('r'), CONCAT(' ', UPPER('r')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('s'), UPPER('s'), CONCAT(' ', UPPER('s')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('t'), UPPER('t'), CONCAT(' ', UPPER('t')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('u'), UPPER('u'), CONCAT(' ', UPPER('u')));
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
-- Non TR chars
INSERT INTO t(col2, col3, col4) VALUES(UPPER('q'), UPPER('q'), CONCAT(' ', UPPER('q')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('x'), UPPER('x'), CONCAT(' ', UPPER('x')));
INSERT INTO t(col2, col3, col4) VALUES(UPPER('w'), UPPER('w'), CONCAT(' ', UPPER('w')));
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