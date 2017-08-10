--+ holdcas on;
set names utf8;
CREATE TABLE test_tr(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR collate utf8_tr_cs_uca DEFAULT NUL, 
vc VARCHAR(32) collate utf8_tr_cs_uca DEFAULT NULL, 
str STRING collate utf8_tr_cs_uca DEFAULT NULL
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

SELECT ch FROM test_tr WHERE ch LIKE 'ç'; 
SELECT ch FROM test_tr WHERE ch LIKE 'ğ'; 
SELECT ch FROM test_tr WHERE ch LIKE 'ı'; 
SELECT ch FROM test_tr WHERE ch LIKE 'I'; 
SELECT ch FROM test_tr WHERE ch LIKE 'ö'; 
SELECT ch FROM test_tr WHERE ch LIKE 'ş'; 
SELECT ch FROM test_tr WHERE ch LIKE 'ü';

SELECT ch FROM test_tr WHERE ch LIKE UPPER('ç'); 
SELECT ch FROM test_tr WHERE ch LIKE UPPER('ğ'); 
SELECT ch FROM test_tr WHERE ch LIKE UPPER('ı'); 
SELECT ch FROM test_tr WHERE ch LIKE UPPER('I'); 
SELECT ch FROM test_tr WHERE ch LIKE UPPER('ö'); 
SELECT ch FROM test_tr WHERE ch LIKE UPPER('ş'); 
SELECT ch FROM test_tr WHERE ch LIKE UPPER('ü');

SELECT vc FROM test_tr WHERE vc LIKE 'ç'; 
SELECT vc FROM test_tr WHERE vc LIKE 'ğ'; 
SELECT vc FROM test_tr WHERE vc LIKE 'ı'; 
SELECT vc FROM test_tr WHERE vc LIKE 'I'; 
SELECT vc FROM test_tr WHERE vc LIKE 'ö'; 
SELECT vc FROM test_tr WHERE vc LIKE 'ş'; 
SELECT vc FROM test_tr WHERE vc LIKE 'ü';

SELECT vc FROM test_tr WHERE vc LIKE UPPER('ç'); 
SELECT vc FROM test_tr WHERE vc LIKE UPPER('ğ'); 
SELECT vc FROM test_tr WHERE vc LIKE UPPER('ı'); 
SELECT vc FROM test_tr WHERE vc LIKE UPPER('I'); 
SELECT vc FROM test_tr WHERE vc LIKE UPPER('ö'); 
SELECT vc FROM test_tr WHERE vc LIKE UPPER('ş'); 
SELECT vc FROM test_tr WHERE vc LIKE UPPER('ü');

SELECT str FROM test_tr WHERE str LIKE '_ç'; 
SELECT str FROM test_tr WHERE str LIKE '_ğ'; 
SELECT str FROM test_tr WHERE str LIKE '_ı'; 
SELECT str FROM test_tr WHERE str LIKE '_I'; 
SELECT str FROM test_tr WHERE str LIKE '_ö'; 
SELECT str FROM test_tr WHERE str LIKE '_ş'; 
SELECT str FROM test_tr WHERE str LIKE '_ü';

SELECT str FROM test_tr WHERE str LIKE UPPER('_ç'); 
SELECT str FROM test_tr WHERE str LIKE UPPER('_ğ'); 
SELECT str FROM test_tr WHERE str LIKE UPPER('_ı'); 
SELECT str FROM test_tr WHERE str LIKE UPPER('_I'); 
SELECT str FROM test_tr WHERE str LIKE UPPER('_ö'); 
SELECT str FROM test_tr WHERE str LIKE UPPER('_ş'); 
SELECT str FROM test_tr WHERE str LIKE UPPER('_ü');

SELECT ch FROM test_tr WHERE ch LIKE 'ı' OR ch LIKE 'I' OR ch LIKE 'i' OR ch LIKE 'İ' ORDER BY str DESC;

SELECT str FROM test_tr WHERE str LIKE '_ı' OR str LIKE '_I' OR str LIKE '_i' OR str LIKE '_İ' ORDER BY str ASC;

SELECT vc FROM test_tr WHERE vc LIKE 'ı' OR vc LIKE 'I' OR vc LIKE 'i' OR vc LIKE 'İ' ORDER BY vc ASC;

DROP TABLE test_tr;
set names iso88591;
commit;
--+ holdcas off;

