--+ holdcas on;
set names utf8;
CREATE TABLE test_cn(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR collate utf8_gen DEFAULT NULL, 
vc VARCHAR(32) collate utf8_gen DEFAULT NULL, 
str STRING collate utf8_gen DEFAULT NULL
);

-- Latin chars
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('a'), UPPER('a'), CONCAT(' ', UPPER('a')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('b'), UPPER('b'), CONCAT(' ', UPPER('b')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('c'), UPPER('c'), CONCAT(' ', UPPER('c')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('d'), UPPER('d'), CONCAT(' ', UPPER('d')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('e'), UPPER('e'), CONCAT(' ', UPPER('e')));

-- TR chars
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('ç'), UPPER('ç'), CONCAT(' ', UPPER('ç')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('ğ'), UPPER('ğ'), CONCAT(' ', UPPER('ğ')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('ı'), UPPER('ı'), CONCAT(' ', UPPER('ı')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('i'), UPPER('i'), CONCAT(' ', UPPER('i')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('ö'), UPPER('ö'), CONCAT(' ', UPPER('ö')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('ş'), UPPER('ş'), CONCAT(' ', UPPER('ş')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('ü'), UPPER('ü'), CONCAT(' ', UPPER('ü')));
-- CH chars
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('啊'), UPPER('啊'), CONCAT(' ', UPPER('啊')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('阿'), UPPER('阿'), CONCAT(' ', UPPER('阿')));
INSERT INTO test_cn(ch, vc, str) VALUES(UPPER('呵'), UPPER('呵'), CONCAT(' ', UPPER('呵')));

SELECT vc, CHAR_LENGTH (vc), LOWER(vc), CHAR_LENGTH(LOWER(vc)), UPPER(vc), CHAR_LENGTH(UPPER(vc)) FROM test_cn  order by 1;

SELECT ch, CHAR_LENGTH (ch), LOWER(ch), CHAR_LENGTH(LOWER(ch)), UPPER(ch), CHAR_LENGTH(UPPER(ch)) FROM test_cn  order by 1;

SELECT str, CHAR_LENGTH (str), LOWER(str), CHAR_LENGTH(LOWER(str)), UPPER(str), CHAR_LENGTH(UPPER(str)) FROM test_cn  order by 1;

DROP TABLE test_cn;


CREATE TABLE test_cn ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_gen);
  
insert into test_cn values (1,'测试');
insert into test_cn values (2,'我们'); 
insert into test_cn values (3,'我们');
insert into test_cn values (103,'我们');
insert into test_cn values (203,'我们');
insert into test_cn values (303,'我们.国家');
insert into test_cn values (403,'我们 生活');
insert into test_cn values (4,'生活');
insert into test_cn values (104,'高兴');
insert into test_cn values (5,'国家'); 
insert into test_cn values (105,'你们好');
insert into test_cn values (205,'今天'); 
insert into test_cn values (6,'明天');
insert into test_cn values (106,'%明天'); 
insert into test_cn values (7,'汽车');
insert into test_cn values (107,'_汽车');
insert into test_cn values (8,'高兴');
insert into test_cn values (9,'科学');
insert into test_cn values (109,'?科学');
insert into test_cn values (10,'程序员');
insert into test_cn values (110,'*程序员');

select id, name, CHAR_LENGTH (name), lower (name), CHAR_LENGTH (lower(name)), upper(name), CHAR_LENGTH (upper(name))  from test_cn order by 1;

select id, name, OCTET_LENGTH (name), lower (name), OCTET_LENGTH (lower(name)), upper(name), OCTET_LENGTH (upper(name))  from test_cn order by 1;

drop table test_cn;
set names iso88591;
commit;
--+ holdcas off;


