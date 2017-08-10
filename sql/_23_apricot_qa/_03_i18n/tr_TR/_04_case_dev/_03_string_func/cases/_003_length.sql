--+ holdcas on;
set names utf8;
CREATE TABLE test_tr(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR  collate utf8_tr_cs DEFAULT NULL, 
vc VARCHAR(32)  collate utf8_tr_cs DEFAULT NULL, 
str STRING  collate utf8_tr_cs DEFAULT NULL
);

INSERT INTO test_tr(ch, vc, str) VALUES('a', 'a', CONCAT(' ', 'a'));
INSERT INTO test_tr(ch, vc, str) VALUES('b', 'b', CONCAT(' ', 'b'));
INSERT INTO test_tr(ch, vc, str) VALUES('c', 'c', CONCAT(' ', 'c'));
INSERT INTO test_tr(ch, vc, str) VALUES('d', 'd', CONCAT(' ', 'd'));
INSERT INTO test_tr(ch, vc, str) VALUES('e', 'e', CONCAT(' ', 'e'));
INSERT INTO test_tr(ch, vc, str) VALUES('f', 'f', CONCAT(' ', 'f'));
INSERT INTO test_tr(ch, vc, str) VALUES('g', 'g', CONCAT(' ', 'g'));
INSERT INTO test_tr(ch, vc, str) VALUES('h', 'h', CONCAT(' ', 'h'));
INSERT INTO test_tr(ch, vc, str) VALUES('j', 'j', CONCAT(' ', 'j'));
INSERT INTO test_tr(ch, vc, str) VALUES('k', 'k', CONCAT(' ', 'k'));
INSERT INTO test_tr(ch, vc, str) VALUES('l', 'l', CONCAT(' ', 'l'));
INSERT INTO test_tr(ch, vc, str) VALUES('m', 'm', CONCAT(' ', 'm'));
INSERT INTO test_tr(ch, vc, str) VALUES('n', 'n', CONCAT(' ', 'n'));
INSERT INTO test_tr(ch, vc, str) VALUES('o', 'o', CONCAT(' ', 'o'));
INSERT INTO test_tr(ch, vc, str) VALUES('p', 'p', CONCAT(' ', 'p'));
INSERT INTO test_tr(ch, vc, str) VALUES('r', 'r', CONCAT(' ', 'r'));
INSERT INTO test_tr(ch, vc, str) VALUES('s', 's', CONCAT(' ', 's'));
INSERT INTO test_tr(ch, vc, str) VALUES('t', 't', CONCAT(' ', 't'));
INSERT INTO test_tr(ch, vc, str) VALUES('u', 'u', CONCAT(' ', 'u'));
INSERT INTO test_tr(ch, vc, str) VALUES('v', 'v', CONCAT(' ', 'v'));
INSERT INTO test_tr(ch, vc, str) VALUES('y', 'y', CONCAT(' ', 'y'));
INSERT INTO test_tr(ch, vc, str) VALUES('z', 'z', CONCAT(' ', 'z'));
-- TR chars
INSERT INTO test_tr(ch, vc, str) VALUES('ç', 'ç', CONCAT(' ', 'ç'));
INSERT INTO test_tr(ch, vc, str) VALUES('ğ', 'ğ', CONCAT(' ', 'ğ'));
INSERT INTO test_tr(ch, vc, str) VALUES('ı', 'ı', CONCAT(' ', 'ı'));
INSERT INTO test_tr(ch, vc, str) VALUES('i', 'i', CONCAT(' ', 'i'));
INSERT INTO test_tr(ch, vc, str) VALUES('ö', 'ö', CONCAT(' ', 'ö'));
INSERT INTO test_tr(ch, vc, str) VALUES('ş', 'ş', CONCAT(' ', 'ş'));
INSERT INTO test_tr(ch, vc, str) VALUES('ü', 'ü', CONCAT(' ', 'ü'));
-- Non TR chars
INSERT INTO test_tr(ch, vc, str) VALUES('q', 'q', CONCAT(' ', 'q'));
INSERT INTO test_tr(ch, vc, str) VALUES('x', 'x', CONCAT(' ', 'x'));
INSERT INTO test_tr(ch, vc, str) VALUES('w', 'w', CONCAT(' ', 'w'));

-- UPPER
-- Latin chars
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('a'), UPPER('a'), CONCAT(' ', UPPER('a')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('b'), UPPER('b'), CONCAT(' ', UPPER('b')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('c'), UPPER('c'), CONCAT(' ', UPPER('c')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('d'), UPPER('d'), CONCAT(' ', UPPER('d')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('e'), UPPER('e'), CONCAT(' ', UPPER('e')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('f'), UPPER('f'), CONCAT(' ', UPPER('f')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('g'), UPPER('g'), CONCAT(' ', UPPER('g')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('h'), UPPER('h'), CONCAT(' ', UPPER('h')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('j'), UPPER('j'), CONCAT(' ', UPPER('j')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('k'), UPPER('k'), CONCAT(' ', UPPER('k')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('l'), UPPER('l'), CONCAT(' ', UPPER('l')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('m'), UPPER('m'), CONCAT(' ', UPPER('m')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('n'), UPPER('n'), CONCAT(' ', UPPER('n')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('o'), UPPER('o'), CONCAT(' ', UPPER('o')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('p'), UPPER('p'), CONCAT(' ', UPPER('p')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('r'), UPPER('r'), CONCAT(' ', UPPER('r')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('s'), UPPER('s'), CONCAT(' ', UPPER('s')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('t'), UPPER('t'), CONCAT(' ', UPPER('t')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('u'), UPPER('u'), CONCAT(' ', UPPER('u')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('v'), UPPER('v'), CONCAT(' ', UPPER('v')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('y'), UPPER('y'), CONCAT(' ', UPPER('y')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('z'), UPPER('z'), CONCAT(' ', UPPER('z')));
-- TR chars
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('ç'), UPPER('ç'), CONCAT(' ', UPPER('ç')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('ğ'), UPPER('ğ'), CONCAT(' ', UPPER('ğ')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('ı'), UPPER('ı'), CONCAT(' ', UPPER('ı')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('i'), UPPER('i'), CONCAT(' ', UPPER('i')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('ö'), UPPER('ö'), CONCAT(' ', UPPER('ö')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('ş'), UPPER('ş'), CONCAT(' ', UPPER('ş')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('ü'), UPPER('ü'), CONCAT(' ', UPPER('ü')));
-- Non TR chars
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('q'), UPPER('q'), CONCAT(' ', UPPER('q')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('x'), UPPER('x'), CONCAT(' ', UPPER('x')));
INSERT INTO test_tr(ch, vc, str) VALUES(UPPER('w'), UPPER('w'), CONCAT(' ', UPPER('w')));

SELECT vc, CHAR_LENGTH(vc), BIT_LENGTH(vc), LENGTH (vc), OCTET_LENGTH (vc) FROM test_tr order by 1;


SELECT vc, CHAR_LENGTH(ch), BIT_LENGTH(ch), LENGTH (ch), OCTET_LENGTH (ch) FROM test_tr order by 1;

SELECT vc, CHAR_LENGTH(str), BIT_LENGTH(str), LENGTH (str), OCTET_LENGTH (str) FROM test_tr order by 1;


DROP TABLE test_tr;



CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20)  collate utf8_tr_cs);
  
insert into test_tr values (1,'Gülen');
insert into test_tr values (2,'Ğüler'); 
insert into test_tr values (3,'İzgi');
insert into test_tr values (103,'Izgi');
insert into test_tr values (203,'İzgı');
insert into test_tr values (303,'İzgı.iZZETtin');
insert into test_tr values (403,'İzgi İxxettin');
insert into test_tr values (4,'İzgü');
insert into test_tr values (104,'İzğü');
insert into test_tr values (5,'İzzettin'); 
insert into test_tr values (105,'İwwettin');
insert into test_tr values (205,'İqqettin'); 
insert into test_tr values (6,'SevINÇ');
insert into test_tr values (106,'%Sevinç'); 
insert into test_tr values (7,'Şükran');
insert into test_tr values (107,'_şÜKran');
insert into test_tr values (8,'İzğü');
insert into test_tr values (9,'İlhan');
insert into test_tr values (109,'?İlhan');
insert into test_tr values (10,'İzgÖ');
insert into test_tr values (110,'*İzgö');

select id, name, CHAR_LENGTH (name), BIT_LENGTH(name), LENGTH(name), OCTET_LENGTH(name) from test_tr order by 1;

drop table test_tr;
set names iso88591;
commit;
--+ holdcas off;

