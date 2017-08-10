--+ holdcas on;
set names utf8;
CREATE TABLE test_ro(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR collate utf8_ro_cs DEFAULT NULL, 
vc VARCHAR(32) collate utf8_ro_cs DEFAULT NULL, 
str STRING collate utf8_ro_cs DEFAULT NULL
);

INSERT INTO test_ro(ch, vc, str) VALUES('a', 'a', CONCAT(' ', 'a'));
INSERT INTO test_ro(ch, vc, str) VALUES('b', 'b', CONCAT(' ', 'b'));
INSERT INTO test_ro(ch, vc, str) VALUES('c', 'c', CONCAT(' ', 'c'));
INSERT INTO test_ro(ch, vc, str) VALUES('d', 'd', CONCAT(' ', 'd'));
INSERT INTO test_ro(ch, vc, str) VALUES('e', 'e', CONCAT(' ', 'e'));
INSERT INTO test_ro(ch, vc, str) VALUES('f', 'f', CONCAT(' ', 'f'));
INSERT INTO test_ro(ch, vc, str) VALUES('g', 'g', CONCAT(' ', 'g'));
INSERT INTO test_ro(ch, vc, str) VALUES('h', 'h', CONCAT(' ', 'h'));
INSERT INTO test_ro(ch, vc, str) VALUES('i', 'i', CONCAT(' ', 'i'));
INSERT INTO test_ro(ch, vc, str) VALUES('j', 'j', CONCAT(' ', 'j'));
INSERT INTO test_ro(ch, vc, str) VALUES('k', 'k', CONCAT(' ', 'k'));
INSERT INTO test_ro(ch, vc, str) VALUES('l', 'l', CONCAT(' ', 'l'));
INSERT INTO test_ro(ch, vc, str) VALUES('m', 'm', CONCAT(' ', 'm'));
INSERT INTO test_ro(ch, vc, str) VALUES('n', 'n', CONCAT(' ', 'n'));
INSERT INTO test_ro(ch, vc, str) VALUES('o', 'o', CONCAT(' ', 'o'));
INSERT INTO test_ro(ch, vc, str) VALUES('p', 'p', CONCAT(' ', 'p'));
INSERT INTO test_ro(ch, vc, str) VALUES('q', 'q', CONCAT(' ', 'q'));
INSERT INTO test_ro(ch, vc, str) VALUES('r', 'r', CONCAT(' ', 'r'));
INSERT INTO test_ro(ch, vc, str) VALUES('s', 's', CONCAT(' ', 's'));
INSERT INTO test_ro(ch, vc, str) VALUES('t', 't', CONCAT(' ', 't'));
INSERT INTO test_ro(ch, vc, str) VALUES('u', 'u', CONCAT(' ', 'u'));
INSERT INTO test_ro(ch, vc, str) VALUES('v', 'v', CONCAT(' ', 'v'));
INSERT INTO test_ro(ch, vc, str) VALUES('w', 'w', CONCAT(' ', 'w'));
INSERT INTO test_ro(ch, vc, str) VALUES('x', 'x', CONCAT(' ', 'x'));
INSERT INTO test_ro(ch, vc, str) VALUES('y', 'y', CONCAT(' ', 'y'));
INSERT INTO test_ro(ch, vc, str) VALUES('z', 'z', CONCAT(' ', 'z'));
-- RO chars
INSERT INTO test_ro(ch, vc, str) VALUES('ă', 'ă', CONCAT(' ', 'ă'));
INSERT INTO test_ro(ch, vc, str) VALUES('â', 'â', CONCAT(' ', 'â'));
INSERT INTO test_ro(ch, vc, str) VALUES('î', 'î', CONCAT(' ', 'î'));
INSERT INTO test_ro(ch, vc, str) VALUES('ș', 'ș', CONCAT(' ', 'ș'));
INSERT INTO test_ro(ch, vc, str) VALUES('ş', 'ş', CONCAT(' ', 'ş'));
INSERT INTO test_ro(ch, vc, str) VALUES('ț', 'ț', CONCAT(' ', 'ț'));
INSERT INTO test_ro(ch, vc, str) VALUES('ţ', 'ţ', CONCAT(' ', 'ţ'));

-- UPPER
-- Latin chars
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('a'), UPPER('a'), CONCAT(' ', UPPER('a')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('b'), UPPER('b'), CONCAT(' ', UPPER('b')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('c'), UPPER('c'), CONCAT(' ', UPPER('c')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('d'), UPPER('d'), CONCAT(' ', UPPER('d')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('e'), UPPER('e'), CONCAT(' ', UPPER('e')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('f'), UPPER('f'), CONCAT(' ', UPPER('f')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('g'), UPPER('g'), CONCAT(' ', UPPER('g')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('h'), UPPER('h'), CONCAT(' ', UPPER('h')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('i'), UPPER('i'), CONCAT(' ', UPPER('i')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('j'), UPPER('j'), CONCAT(' ', UPPER('j')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('k'), UPPER('k'), CONCAT(' ', UPPER('k')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('l'), UPPER('l'), CONCAT(' ', UPPER('l')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('m'), UPPER('m'), CONCAT(' ', UPPER('m')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('n'), UPPER('n'), CONCAT(' ', UPPER('n')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('o'), UPPER('o'), CONCAT(' ', UPPER('o')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('p'), UPPER('p'), CONCAT(' ', UPPER('p')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('q'), UPPER('q'), CONCAT(' ', UPPER('q')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('r'), UPPER('r'), CONCAT(' ', UPPER('r')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('s'), UPPER('s'), CONCAT(' ', UPPER('s')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('t'), UPPER('t'), CONCAT(' ', UPPER('t')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('u'), UPPER('u'), CONCAT(' ', UPPER('u')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('v'), UPPER('v'), CONCAT(' ', UPPER('v')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('w'), UPPER('w'), CONCAT(' ', UPPER('w')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('x'), UPPER('x'), CONCAT(' ', UPPER('x')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('y'), UPPER('y'), CONCAT(' ', UPPER('y')));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('z'), UPPER('z'), CONCAT(' ', UPPER('z')));
-- RO chars
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('ă' collate utf8_ro_cs), UPPER('ă' collate utf8_ro_cs), CONCAT(' ', UPPER('ă' collate utf8_ro_cs)));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('â' collate utf8_ro_cs), UPPER('â' collate utf8_ro_cs), CONCAT(' ', UPPER('â' collate utf8_ro_cs)));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('î' collate utf8_ro_cs), UPPER('î' collate utf8_ro_cs), CONCAT(' ', UPPER('î' collate utf8_ro_cs)));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('ș' collate utf8_ro_cs), UPPER('ș' collate utf8_ro_cs), CONCAT(' ', UPPER('ș' collate utf8_ro_cs)));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('ş' collate utf8_ro_cs), UPPER('ş' collate utf8_ro_cs), CONCAT(' ', UPPER('ş' collate utf8_ro_cs)));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('ț' collate utf8_ro_cs), UPPER('ț' collate utf8_ro_cs), CONCAT(' ', UPPER('ț' collate utf8_ro_cs)));
INSERT INTO test_ro(ch, vc, str) VALUES(UPPER('ţ' collate utf8_ro_cs), UPPER('ţ' collate utf8_ro_cs), CONCAT(' ', UPPER('ţ' collate utf8_ro_cs)));


SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE 'ă' order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE 'â' order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE 'î' order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE 'ș' order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE 'ş' order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE 'ț' order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE 'ţ' order by ch collate utf8_ro_cs, 2;

SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE UPPER('ă' collate utf8_ro_cs) order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE UPPER('â' collate utf8_ro_cs) order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE UPPER('î' collate utf8_ro_cs) order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE UPPER('ș' collate utf8_ro_cs) order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE UPPER('ş' collate utf8_ro_cs) order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE UPPER('ț' collate utf8_ro_cs) order by ch collate utf8_ro_cs, 2;
SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE UPPER('ţ' collate utf8_ro_cs) order by ch collate utf8_ro_cs, 2;

SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE 'ă' order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE 'â' order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE 'î' order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE 'ș' order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE 'ş' order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE 'ț' order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE 'ţ' order by vc collate utf8_ro_cs, 2;

SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE UPPER('ă' collate utf8_ro_cs) order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE UPPER('â' collate utf8_ro_cs) order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE UPPER('î' collate utf8_ro_cs) order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE UPPER('ș' collate utf8_ro_cs) order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE UPPER('ş' collate utf8_ro_cs) order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE UPPER('ț' collate utf8_ro_cs) order by vc collate utf8_ro_cs, 2;
SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE UPPER('ţ' collate utf8_ro_cs) order by vc collate utf8_ro_cs, 2;

SELECT str, hex(str) FROM test_ro WHERE str LIKE '_ă' order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE '_â' order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE '_î' order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE '_ș' order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE '_ş' order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE '_ț' order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE '_ţ' order by str collate utf8_ro_cs, 2;

SELECT str, hex(str) FROM test_ro WHERE str LIKE UPPER('_ă' collate utf8_ro_cs) order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE UPPER('_â' collate utf8_ro_cs) order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE UPPER('_î' collate utf8_ro_cs) order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE UPPER('_ș' collate utf8_ro_cs) order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE UPPER('_ş' collate utf8_ro_cs) order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE UPPER('_ț' collate utf8_ro_cs) order by str collate utf8_ro_cs, 2;
SELECT str, hex(str) FROM test_ro WHERE str LIKE UPPER('_ţ' collate utf8_ro_cs) order by str collate utf8_ro_cs, 2;

SELECT ch, hex(ch) FROM test_ro WHERE ch LIKE 'I' OR ch LIKE 'î' OR ch LIKE 'i' OR ch LIKE 'Î' ORDER BY str collate utf8_ro_cs DESC, 2;

SELECT str, hex(str) FROM test_ro WHERE str LIKE '_ș' OR str LIKE '_Ș' OR str LIKE '_ş' OR str LIKE '_Ş' OR str LIKE '_s' OR str LIKE '_S' ORDER BY str collate utf8_ro_cs ASC, 2;

SELECT vc, hex(vc) FROM test_ro WHERE vc LIKE 'A' OR vc LIKE 'Ă' OR vc LIKE 'Â' OR vc LIKE 'a' OR vc LIKE 'ă' OR vc LIKE 'â' ORDER BY vc collate utf8_ro_cs ASC, 2;

DROP TABLE test_ro;
set names iso88591;
commit;
--+ holdcas off;

