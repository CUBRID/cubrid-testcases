--+ holdcas on;
set names utf8;
CREATE TABLE test_ro(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR collate utf8_ro_cs DEFAULT NULL, 
vc VARCHAR(32) collate utf8_ro_cs DEFAULT NULL, 
str STRING collate utf8_ro_cs DEFAULT NULL
);

INSERT INTO test_ro(ch, vc, str) VALUES('a', 'a', CONCAT_WS(' ', 'a'));
INSERT INTO test_ro(ch, vc, str) VALUES('b', 'b', CONCAT_WS(' ', 'b'));
INSERT INTO test_ro(ch, vc, str) VALUES('c', 'c', CONCAT_WS(' ', 'c'));
-- RO chars
INSERT INTO test_ro(ch, vc, str) VALUES('Ș', 'Ș', CONCAT_WS(' ', 'Ș'));
INSERT INTO test_ro(ch, vc, str) VALUES('Ţ', 'Ţ', CONCAT_WS(' ', 'Ţ'));
-- Chinese chars
INSERT INTO test_ro(ch, vc, str) VALUES('好', '好', CONCAT_WS(' ', '好'));
-- UPPER
-- Latin chars
INSERT INTO test_ro(ch, vc, str) VALUES(LOWER (UPPER('a')), LOWER (UPPER('a')), CONCAT_WS(' ', LOWER (UPPER('a'))));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('b'), UPPER('b'), CONCAT_WS(' ', UPPER('b')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('c'), UPPER('c'), CONCAT_WS(' ', UPPER('c')));
-- RO chars
INSERT INTO test_ro(ch, vc, str) VALUES(LOWER (UPPER('Ș')), LOWER (UPPER('Ș')), CONCAT_WS(' ', LOWER (UPPER('Ș'))));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('â'), UPPER('â'), CONCAT_WS(' ', UPPER('â')));

--Test
SELECT vc, CHAR_LENGTH(vc), BIT_LENGTH(vc), LENGTH (vc), OCTET_LENGTH (vc) FROM test_ro order by 1;

--Test
SELECT vc, CHAR_LENGTH(ch), BIT_LENGTH(ch), LENGTH (ch), OCTET_LENGTH (ch) FROM test_ro order by 1;
--Test
SELECT vc, CHAR_LENGTH(str), BIT_LENGTH(str), LENGTH (str), OCTET_LENGTH (str) FROM test_ro order by 1;


DROP TABLE test_ro;



CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ro_cs);
  
insert into test_ro values (1,'râdeți');
insert into test_ro values (2,CONCAT('râdeți',null)); 
insert into test_ro values (3,CONCAT_WS('Doriți','abc'));
insert into test_ro values (103,CONCAT('Doriți','你好'));
insert into test_ro values (203,'vremea');
insert into test_ro values (303,'vremea.iZZETtin');


--Test
select id, name, CHAR_LENGTH (name), BIT_LENGTH(name), LENGTH(name), OCTET_LENGTH(name) from test_ro order by 1;

drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;

