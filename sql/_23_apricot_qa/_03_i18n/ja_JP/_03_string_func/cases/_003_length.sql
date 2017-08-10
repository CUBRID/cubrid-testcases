--+ holdcas on;
set names utf8;
CREATE TABLE test_jp(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR utf8_ja_exp DEFAULT NULL, 
vc VARCHAR(32) utf8_ja_exp DEFAULT NULL, 
str STRING utf8_ja_exp DEFAULT NULL
);
-- Latin chars
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('a'), UPPER('a'), CONCAT(' ', UPPER('a')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('b'), UPPER('b'), CONCAT(' ', UPPER('b')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('c'), UPPER('c'), CONCAT(' ', UPPER('c')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('d'), UPPER('d'), CONCAT(' ', UPPER('d')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('e'), UPPER('e'), CONCAT(' ', UPPER('e')));

-- TR chars
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('ぁ'), UPPER('ぁ'), CONCAT(' ', UPPER('ぁ')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('ぃ'), UPPER('ぃ'), CONCAT(' ', UPPER('ぃ')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('ゥ'), UPPER('ゥ'), CONCAT(' ', UPPER('ゥ')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('ン'), UPPER('ン'), CONCAT(' ', UPPER('ン')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('亞'), UPPER('亞'), CONCAT(' ', UPPER('亞')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('壱'), UPPER('壱'), CONCAT(' ', UPPER('壱')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('詳'), UPPER('詳'), CONCAT(' ', UPPER('詳')));
-- CH chars
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('啊'), UPPER('啊'), CONCAT(' ', UPPER('啊')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('阿'), UPPER('阿'), CONCAT(' ', UPPER('阿')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('呵'), UPPER('呵'), CONCAT(' ', UPPER('呵')));

SELECT vc, CHAR_LENGTH(vc), BIT_LENGTH(vc), LENGTH (vc), OCTET_LENGTH (vc) FROM test_jp order by 1;


SELECT vc, CHAR_LENGTH(ch), BIT_LENGTH(ch), LENGTH (ch), OCTET_LENGTH (ch) FROM test_jp order by 1;

SELECT vc, CHAR_LENGTH(str), BIT_LENGTH(str), LENGTH (str), OCTET_LENGTH (str) FROM test_jp order by 1;


DROP TABLE test_jp;



CREATE TABLE test_jp ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ja_exp);
  
insert into test_jp values (1,'午後');
insert into test_jp values (2,'午前'); 
insert into test_jp values (3,'午前');
insert into test_jp values (103,'午前');
insert into test_jp values (203,'午前');
insert into test_jp values (303,'午前.西暦');
insert into test_jp values (403,'午前 紀元');
insert into test_jp values (4,'紀元');
insert into test_jp values (104,'ムモ');
insert into test_jp values (5,'西暦'); 
insert into test_jp values (105,'韓国語');
insert into test_jp values (205,'八荣'); 
insert into test_jp values (6,'基盤');
insert into test_jp values (106,'%基盤'); 
insert into test_jp values (7,'簡体');
insert into test_jp values (107,'_簡体');
insert into test_jp values (8,'ムモ');
insert into test_jp values (9,'繁体');
insert into test_jp values (109,'?繁体');
insert into test_jp values (10,'中国語');
insert into test_jp values (110,'*中国語');

select id, name, CHAR_LENGTH (name), BIT_LENGTH(name), LENGTH(name), OCTET_LENGTH(name) from test_jp order by 1;

drop table test_jp;
set names iso88591;
commit;
--+ holdcas off;

