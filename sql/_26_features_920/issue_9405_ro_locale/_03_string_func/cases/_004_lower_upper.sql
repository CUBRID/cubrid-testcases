--+ holdcas on;
set names utf8;
CREATE TABLE test_ro(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR collate utf8_ro_cs DEFAULT NULL, 
vc VARCHAR(32) collate utf8_ro_cs DEFAULT NULL, 
str STRING collate utf8_ro_cs DEFAULT NULL
);

-- Latin chars
INSERT INTO test_ro(ch, vc, str) VALUES('G', 'g', CONCAT_WS(' ', 'g'));
-- RO chars
INSERT INTO test_ro(ch, vc, str) VALUES('Ă', 'ă', CONCAT(' ', 'ă'));
INSERT INTO test_ro(ch, vc, str) VALUES('Â', 'â', CONCAT(' ', 'Â'));
INSERT INTO test_ro(ch, vc, str) VALUES('Î', 'î', CONCAT(' ', 'î'));
INSERT INTO test_ro(ch, vc, str) VALUES('Ș', 'ș', CONCAT(' ', 'Ș'));
INSERT INTO test_ro(ch, vc, str) VALUES('Ț', 'ț', CONCAT(null, 'ț'));
INSERT INTO test_ro(ch, vc, str) VALUES('ş', 'ţ', CONCAT('Ş', 'Ţ'));
-- Non RO chars
INSERT INTO test_ro(ch, vc, str) VALUES('ğ', 'ğ', CONCAT(' ', 'ğ'));
--mix Latin and RO chars
INSERT INTO test_ro(ch, vc, str) VALUES('q', 'ș', CONCAT_WS('ș', 'q'));
INSERT INTO test_ro(ch, vc, str) VALUES('q', 'ț', CONCAT('Ț', 'z'));



--test
SELECT vc, CHAR_LENGTH (vc), LOWER(vc), CHAR_LENGTH(LOWER(vc)), UPPER(vc), CHAR_LENGTH(UPPER(vc)) FROM test_ro  order by 1;
--test
SELECT ch, CHAR_LENGTH (ch), LOWER(ch), CHAR_LENGTH(LOWER(ch)), UPPER(ch), CHAR_LENGTH(UPPER(ch)) FROM test_ro  order by 1;
--test
SELECT str, CHAR_LENGTH (str), LOWER(str), CHAR_LENGTH(LOWER(str)), UPPER(str), CHAR_LENGTH(UPPER(str)) FROM test_ro  order by 1;

DROP TABLE test_ro;


CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ro_cs);
  
insert into test_ro values (1,'Sînt');
insert into test_ro values (2,CONCAT('Sînt',null)); 
insert into test_ro values (3,CONCAT_WS('ÎnsănătoȘire','abc'));
insert into test_ro values (103,CONCAT('ÎnsănătoȘire','你好'));
insert into test_ro values (203,'ăȘțÎ');
insert into test_ro values (303,'ăȘțÎ.aa*bb$CC');

--test
select id, name, CHAR_LENGTH (name), lower (name), CHAR_LENGTH (lower(name)), upper(name), CHAR_LENGTH (upper(name))  from test_ro order by 1;
--test
select id, name, OCTET_LENGTH (name), lower (name), OCTET_LENGTH (lower(name)), upper(name), OCTET_LENGTH (upper(name))  from test_ro order by 1;

drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;


