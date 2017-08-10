--+ holdcas on;
set names utf8;
CREATE TABLE test_kh(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR  collate utf8_km_exp DEFAULT NULL, 
vc VARCHAR(32)  collate utf8_km_exp DEFAULT NULL, 
str STRING collate utf8_km_exp DEFAULT NULL
);


INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('ក'), UPPER('ក'), CONCAT(' ', UPPER('ក')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('ខ'), UPPER('ខ'), CONCAT(' ', UPPER('ខ')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('គ'), UPPER('គ'), CONCAT(' ', UPPER('គ')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('ឃ'), UPPER('ឃ'), CONCAT(' ', UPPER('ឃ')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('ង'), UPPER('ង'), CONCAT(' ', UPPER('ង')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('ថ'), UPPER('ថ'), CONCAT(' ', UPPER('ថ')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('ស'), UPPER('ស'), CONCAT(' ', UPPER('ស')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('ហ'), UPPER('ហ'), CONCAT(' ', UPPER('ហ')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('ឯ'), UPPER('ឯ'), CONCAT(' ', UPPER('ឯ')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('ឿ'), UPPER('ឿ'), CONCAT(' ', UPPER('ឿ')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('៏'), UPPER('៏'), CONCAT(' ', UPPER('៏')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('៝'), UPPER('៝'), CONCAT(' ', UPPER('៝')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('៩'), UPPER('៩'), CONCAT(' ', UPPER('៩')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('៰'), UPPER('៰'), CONCAT(' ', UPPER('៰')));
INSERT INTO test_kh(ch, vc, str) VALUES(UPPER('៹'), UPPER('៹'), CONCAT(' ', UPPER('៹')));

SELECT vc, CHAR_LENGTH (vc), LOWER(vc), CHAR_LENGTH(LOWER(vc)), UPPER(vc), CHAR_LENGTH(UPPER(vc)) FROM test_kh  order by 1;

SELECT ch, CHAR_LENGTH (ch), LOWER(ch), CHAR_LENGTH(LOWER(ch)), UPPER(ch), CHAR_LENGTH(UPPER(ch)) FROM test_kh  order by 1;

SELECT str, CHAR_LENGTH (str), LOWER(str), CHAR_LENGTH(LOWER(str)), UPPER(str), CHAR_LENGTH(UPPER(str)) FROM test_kh  order by 1;

DROP TABLE test_kh;


CREATE TABLE test_kh ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_km_exp);
  
insert into test_kh values (1,'អា');
insert into test_kh values (2,'ច'); 
insert into test_kh values (3,'ច');
insert into test_kh values (103,'ច');
insert into test_kh values (203,'ច');
insert into test_kh values (303,'ច.អ');
insert into test_kh values (403,'ច ពុ');
insert into test_kh values (4,'ពុ');
insert into test_kh values (104,'ព្រ');
insert into test_kh values (5,'អ'); 
insert into test_kh values (105,'សុ');
insert into test_kh values (205,'សុ'); 
insert into test_kh values (6,'មករា');
insert into test_kh values (106,'%មករា'); 
insert into test_kh values (7,'កុម្ភៈ');
insert into test_kh values (107,'_កុម្ភៈ');
insert into test_kh values (8,'ព្រ');
insert into test_kh values (9,'មិនា');
insert into test_kh values (109,'?មិនា');
insert into test_kh values (10,'មេសា');
insert into test_kh values (110,'*មេសា');

select id, name, CHAR_LENGTH (name), lower (name), CHAR_LENGTH (lower(name)), upper(name), CHAR_LENGTH (upper(name))  from test_kh order by 1;

select id, name, OCTET_LENGTH (name), lower (name), OCTET_LENGTH (lower(name)), upper(name), OCTET_LENGTH (upper(name))  from test_kh order by 1;

drop table test_kh;
set names iso88591;
commit;
--+ holdcas off;
