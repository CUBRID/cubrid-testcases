--+ holdcas on;
set names utf8;
CREATE TABLE test_tr(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR collate utf8_tr_cs_uca DEFAULT NULL, 
vc VARCHAR(32) collate utf8_tr_cs_uca DEFAULT NULL, 
str STRING collate utf8_tr_cs_uca DEFAULT NULL
);

-- Latin chars
INSERT INTO test_tr(ch, vc, str) VALUES('z', 'z', CONCAT_WS(' ', 'z'));
-- TR chars
INSERT INTO test_tr(ch, vc, str) VALUES('ç', 'ç', CONCAT(' ', 'ç'));
INSERT INTO test_tr(ch, vc, str) VALUES('ğ', 'ğ', CONCAT(' ', 'ğ'));
INSERT INTO test_tr(ch, vc, str) VALUES('ı', 'ı', CONCAT(' ', 'ı'));
INSERT INTO test_tr(ch, vc, str) VALUES('i', 'i', CONCAT(' ', 'i'));
INSERT INTO test_tr(ch, vc, str) VALUES('ö', 'ö', CONCAT(null, 'ö'));
INSERT INTO test_tr(ch, vc, str) VALUES('ş', 'ş', CONCAT(' ', 'ş'));
INSERT INTO test_tr(ch, vc, str) VALUES('ü', 'ü', CONCAT_WS(null, 'ü'));
-- Non TR chars
INSERT INTO test_tr(ch, vc, str) VALUES('q', 'q', CONCAT(' ', 'q'));
--mix Latin and TR chars
INSERT INTO test_tr(ch, vc, str) VALUES('q', 'q', CONCAT_WS('ü', 'q'));
INSERT INTO test_tr(ch, vc, str) VALUES('q', 'q', CONCAT('ü', 'z'));



--test
SELECT vc, CHAR_LENGTH (vc), LOWER(vc), CHAR_LENGTH(LOWER(vc)), UPPER(vc), CHAR_LENGTH(UPPER(vc)) FROM test_tr  order by 1;
--test
SELECT ch, CHAR_LENGTH (ch), LOWER(ch), CHAR_LENGTH(LOWER(ch)), UPPER(ch), CHAR_LENGTH(UPPER(ch)) FROM test_tr  order by 1;
--test
SELECT str, CHAR_LENGTH (str), LOWER(str), CHAR_LENGTH(LOWER(str)), UPPER(str), CHAR_LENGTH(UPPER(str)) FROM test_tr  order by 1;

DROP TABLE test_tr;


CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_tr_cs_uca);
  
insert into test_tr values (1,'Gülen');
insert into test_tr values (2,CONCAT('Ğüler',null)); 
insert into test_tr values (3,CONCAT_WS('İzgi','abc'));
insert into test_tr values (103,CONCAT('Izgi','河蟹'));
insert into test_tr values (203,'İzgı');
insert into test_tr values (303,'İzgı.iZZETtin');

--test
select id, name, CHAR_LENGTH (name), lower (name), CHAR_LENGTH (lower(name)), upper(name), CHAR_LENGTH (upper(name))  from test_tr order by 1;
--test
select id, name, OCTET_LENGTH (name), lower (name), OCTET_LENGTH (lower(name)), upper(name), OCTET_LENGTH (upper(name))  from test_tr order by 1;

drop table test_tr;
set names iso88591;
commit;
--+ holdcas off;


