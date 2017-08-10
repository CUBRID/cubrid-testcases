--+ holdcas on;
set names utf8;
CREATE TABLE test_tr(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR collate utf8_tr_cs_uca DEFAULT NULL, 
vc VARCHAR(32) collate utf8_tr_cs_uca DEFAULT NULL, 
str STRING collate utf8_tr_cs_uca DEFAULT NULL
);

INSERT INTO test_tr(ch, vc, str) VALUES('a', 'a', CONCAT_WS(' ', 'a'));
INSERT INTO test_tr(ch, vc, str) VALUES('b', 'b', CONCAT_WS(' ', 'b'));
INSERT INTO test_tr(ch, vc, str) VALUES('c', 'c', CONCAT_WS(' ', 'c'));
-- TR chars
INSERT INTO test_tr(ch, vc, str) VALUES('ç', 'ç', CONCAT_WS(' ', 'ç'));
INSERT INTO test_tr(ch, vc, str) VALUES('ğ', 'ğ', CONCAT_WS(' ', 'ğ'));
-- Non TR chars
INSERT INTO test_tr(ch, vc, str) VALUES('q', 'q', CONCAT_WS(' ', 'q'));
-- Chinese chars
INSERT INTO test_tr(ch, vc, str) VALUES('好', '好', CONCAT_WS(' ', '好'));
-- UPPER
-- Latin chars
INSERT INTO test_tr(ch, vc, str) VALUES(LOWER (UPPER('a')), LOWER (UPPER('a')), CONCAT_WS(' ', LOWER (UPPER('a'))));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('b'), UPPER('b'), CONCAT_WS(' ', UPPER('b')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('c'), UPPER('c'), CONCAT_WS(' ', UPPER('c')));
-- TR chars
INSERT INTO test_tr(ch, vc, str) VALUES(LOWER (UPPER('ç')), LOWER (UPPER('ç')), CONCAT_WS(' ', LOWER (UPPER('ç'))));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('ğ'), UPPER('ğ'), CONCAT_WS(' ', UPPER('ğ')));
-- Non TR chars
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('q'), UPPER('q'), CONCAT_WS(' ', UPPER('q')));

--Test
SELECT vc, CHAR_LENGTH(vc), BIT_LENGTH(vc), LENGTH (vc), OCTET_LENGTH (vc) FROM test_tr order by 1;

--Test
SELECT vc, CHAR_LENGTH(ch), BIT_LENGTH(ch), LENGTH (ch), OCTET_LENGTH (ch) FROM test_tr order by 1;
--Test
SELECT vc, CHAR_LENGTH(str), BIT_LENGTH(str), LENGTH (str), OCTET_LENGTH (str) FROM test_tr order by 1;


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


--Test
select id, name, CHAR_LENGTH (name), BIT_LENGTH(name), LENGTH(name), OCTET_LENGTH(name) from test_tr order by 1;

drop table test_tr;
set names iso88591;
commit;
--+ holdcas off;

