--+ holdcas on;
set names utf8;
CREATE TABLE test_tr(
id INT NOT NULL AUTO_INCREMENT, 
ch CHAR collate utf8_gen DEFAULT NULL, 
vc VARCHAR(32) collate utf8_gen DEFAULT NULL, 
str STRING  collate utf8_gen DEFAULT NULL
);


INSERT INTO test_tr(ch, vc, str) VALUES('一', '一', CONCAT(' ', '一'));
INSERT INTO test_tr(ch, vc, str) VALUES('十', '十', CONCAT(' ', '十'));
INSERT INTO test_tr(ch, vc, str) VALUES('木', '木', CONCAT(' ', '木'));
INSERT INTO test_tr(ch, vc, str) VALUES('水', '水', CONCAT(' ', '水'));
INSERT INTO test_tr(ch, vc, str) VALUES('火', '火', CONCAT(' ', '火'));
INSERT INTO test_tr(ch, vc, str) VALUES('土', '土', CONCAT(' ', '土'));



-- TR chars
INSERT INTO test_tr(ch, vc, str) VALUES(LOWER('一'), LOWER('一'), CONCAT(' ', LOWER('一')));
INSERT INTO test_tr(ch, vc, str) VALUES(LOWER('十'), LOWER('十'), CONCAT(' ', LOWER('十')));
INSERT INTO test_tr(ch, vc, str) VALUES(LOWER('木'), LOWER('木'), CONCAT(' ', LOWER('木')));
INSERT INTO test_tr(ch, vc, str) VALUES(LOWER('水'), LOWER('水'), CONCAT(' ', LOWER('水')));
INSERT INTO test_tr(ch, vc, str) VALUES(LOWER('水'), LOWER('水'), CONCAT(' ', LOWER('水')));
INSERT INTO test_tr(ch, vc, str) VALUES(LOWER('火'), LOWER('火'), CONCAT(' ', LOWER('火')));
INSERT INTO test_tr(ch, vc, str) VALUES(LOWER('土'), LOWER('土'), CONCAT(' ', LOWER('土')));

SELECT ch FROM test_tr WHERE ch LIKE '一'; 
SELECT ch FROM test_tr WHERE ch LIKE '十'; 
SELECT ch FROM test_tr WHERE ch LIKE '木'; 
SELECT ch FROM test_tr WHERE ch LIKE '水'; 
SELECT ch FROM test_tr WHERE ch LIKE '水'; 
SELECT ch FROM test_tr WHERE ch LIKE '火'; 
SELECT ch FROM test_tr WHERE ch LIKE '土';

SELECT ch FROM test_tr WHERE ch LIKE LOWER('一'); 
SELECT ch FROM test_tr WHERE ch LIKE LOWER('十'); 
SELECT ch FROM test_tr WHERE ch LIKE LOWER('木'); 
SELECT ch FROM test_tr WHERE ch LIKE LOWER('水'); 
SELECT ch FROM test_tr WHERE ch LIKE LOWER('水'); 
SELECT ch FROM test_tr WHERE ch LIKE LOWER('火'); 
SELECT ch FROM test_tr WHERE ch LIKE LOWER('土');

SELECT vc FROM test_tr WHERE vc LIKE '一'; 
SELECT vc FROM test_tr WHERE vc LIKE '十'; 
SELECT vc FROM test_tr WHERE vc LIKE '木'; 
SELECT vc FROM test_tr WHERE vc LIKE '水'; 
SELECT vc FROM test_tr WHERE vc LIKE '水'; 
SELECT vc FROM test_tr WHERE vc LIKE '火'; 
SELECT vc FROM test_tr WHERE vc LIKE '土';

SELECT vc FROM test_tr WHERE vc LIKE LOWER('一'); 
SELECT vc FROM test_tr WHERE vc LIKE LOWER('十'); 
SELECT vc FROM test_tr WHERE vc LIKE LOWER('木'); 
SELECT vc FROM test_tr WHERE vc LIKE LOWER('水'); 
SELECT vc FROM test_tr WHERE vc LIKE LOWER('水'); 
SELECT vc FROM test_tr WHERE vc LIKE LOWER('火'); 
SELECT vc FROM test_tr WHERE vc LIKE LOWER('土');

SELECT str FROM test_tr WHERE str LIKE '_一'; 
SELECT str FROM test_tr WHERE str LIKE '_十'; 
SELECT str FROM test_tr WHERE str LIKE '_木'; 
SELECT str FROM test_tr WHERE str LIKE '电'; 
SELECT str FROM test_tr WHERE str LIKE '_水'; 
SELECT str FROM test_tr WHERE str LIKE '_火'; 
SELECT str FROM test_tr WHERE str LIKE '_土';

SELECT str FROM test_tr WHERE str LIKE LOWER('_一'); 
SELECT str FROM test_tr WHERE str LIKE LOWER('_十'); 
SELECT str FROM test_tr WHERE str LIKE LOWER('_木'); 
SELECT str FROM test_tr WHERE str LIKE LOWER('电'); 
SELECT str FROM test_tr WHERE str LIKE LOWER('_水'); 
SELECT str FROM test_tr WHERE str LIKE LOWER('_火'); 
SELECT str FROM test_tr WHERE str LIKE LOWER('_土');

SELECT ch FROM test_tr WHERE ch LIKE '木' OR ch LIKE '水' OR ch LIKE '水' OR ch LIKE '水' ORDER BY str DESC;

SELECT str FROM test_tr WHERE str LIKE '_木' OR str LIKE '电' OR str LIKE '电' OR str LIKE '电' ORDER BY str ASC;

SELECT vc FROM test_tr WHERE vc LIKE '木' OR vc LIKE '水' OR vc LIKE '水' OR vc LIKE '水' ORDER BY vc ASC;

DROP TABLE test_tr;
set names iso88591;
commit;
--+ holdcas off;
