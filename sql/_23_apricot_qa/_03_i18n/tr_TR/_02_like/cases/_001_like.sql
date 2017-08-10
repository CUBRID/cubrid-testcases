--+ holdcas on;
set names utf8;
CREATE TABLE test_tr(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR collate utf8_tr_cs_uca DEFAULT NULL, 
vc VARCHAR(32) collate utf8_tr_cs_uca DEFAULT NULL, 
str STRING collate utf8_tr_cs_uca DEFAULT NULL
);
INSERT INTO test_tr(ch, vc, str) VALUES('a', 'a', CONCAT(' ', 'a'));
INSERT INTO test_tr(ch, vc, str) VALUES('乡', '乡', CONCAT(' ', '乡'));
--test
SELECT str FROM test_tr WHERE str LIKE 'a'; 

DROP TABLE test_tr;
set names iso88591;
commit;
--+ holdcas off;