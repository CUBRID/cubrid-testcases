--+ holdcas on;
set names utf8;
CREATE TABLE test_jp(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR utf8_ja_exp DEFAULT NULL, 
vc VARCHAR(32) utf8_ja_exp DEFAULT NULL, 
str STRING utf8_ja_exp DEFAULT NULL
);

-- Latin chars
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('ぁ'), UPPER('ぁ'), CONCAT(' ', UPPER('ぁ')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('ぃ'), UPPER('ぃ'), CONCAT(' ', UPPER('ぃ')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('ぇ'), UPPER('ぇ'), CONCAT(' ', UPPER('ぇ')));
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
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('語'), UPPER('語'), CONCAT(' ', UPPER('語')));
INSERT INTO test_jp(ch, vc, str) VALUES(UPPER('1'), UPPER('1'), CONCAT(' ', UPPER('1')));

SELECT vc, CHAR_LENGTH (vc), LOWER(vc), CHAR_LENGTH(LOWER(vc)), UPPER(vc), CHAR_LENGTH(UPPER(vc)) FROM test_jp  order by 1;

SELECT ch, CHAR_LENGTH (ch), LOWER(ch), CHAR_LENGTH(LOWER(ch)), UPPER(ch), CHAR_LENGTH(UPPER(ch)) FROM test_jp  order by 1;

SELECT str, CHAR_LENGTH (str), LOWER(str), CHAR_LENGTH(LOWER(str)), UPPER(str), CHAR_LENGTH(UPPER(str)) FROM test_jp  order by 1;

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
insert into test_jp values (205,'亜荣'); 
insert into test_jp values (6,'基盤');
insert into test_jp values (106,'%基盤'); 
insert into test_jp values (7,'簡体');
insert into test_jp values (107,'_簡体');
insert into test_jp values (8,'ムモ');
insert into test_jp values (9,'繁体');
insert into test_jp values (109,'?繁体');
insert into test_jp values (10,'中国語');
insert into test_jp values (110,'*中国語');

select id, name, CHAR_LENGTH (name), lower (name), CHAR_LENGTH (lower(name)), upper(name), CHAR_LENGTH (upper(name))  from test_jp order by 1;

select id, name, OCTET_LENGTH (name), lower (name), OCTET_LENGTH (lower(name)), upper(name), OCTET_LENGTH (upper(name))  from test_jp order by 1;

drop table test_jp;
set names iso88591;
commit;
--+ holdcas off;

