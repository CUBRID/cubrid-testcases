--+ holdcas on;
 
create table t (col1 VARCHAR(10) collate utf8_gen not null, col2 VARCHAR(10) collate utf8_gen); 
INSERT INTO  t VALUES('a', UPPER( 'a'));
INSERT INTO  t VALUES('b', UPPER( 'b'));
INSERT INTO  t VALUES('c', UPPER( 'c'));
INSERT INTO  t VALUES('v', UPPER( 'v'));
INSERT INTO  t VALUES('y', UPPER( 'y'));
INSERT INTO  t VALUES('z', UPPER( 'z'));
-- TR chars              
INSERT INTO  t VALUES('ç', UPPER( 'ç'));
INSERT INTO  t VALUES('ğ', UPPER( 'ğ'));
INSERT INTO  t VALUES('ı', UPPER( 'ı'));
INSERT INTO  t VALUES('i', UPPER( 'i'));
INSERT INTO  t VALUES('ö', UPPER( 'ö'));
INSERT INTO  t VALUES('ş', UPPER( 'ş'));
INSERT INTO  t VALUES('ü', UPPER( 'ü'));
-- CN chars              
INSERT INTO  t VALUES('ē', UPPER('ē'));
INSERT INTO  t VALUES('ǎ', UPPER('ǎ'));
INSERT INTO  t VALUES('Ā', UPPER('Ā'));
INSERT INTO  t VALUES('Ń', UPPER('Ń'));
INSERT INTO  t VALUES('ǖ', UPPER('ǖ'));
INSERT INTO  t VALUES('Ǘ', UPPER( 'Ǘ'));
INSERT INTO  t VALUES('1', UPPER( '1'));
INSERT INTO  t VALUES('0', UPPER( '0'));
INSERT INTO  t VALUES('9', UPPER( '9'));
INSERT INTO  t VALUES('阿',UPPER( '阿'));
INSERT INTO  t VALUES('呵',UPPER( '呵'));
INSERT INTO  t VALUES('爸',UPPER( '爸'));
INSERT INTO  t VALUES('一',UPPER( '一'));
INSERT INTO  t VALUES('七',UPPER( '七'));
INSERT INTO  t VALUES('再',UPPER( '再'));
INSERT INTO  t VALUES('帀',UPPER( '帀'));


create index idx  on t (col1, col2); 

--test
select  * from t order by col1; 
--test
select  * from t using index none order by col1 desc; 

drop t;
set names iso88591;
 
commit;
--+ holdcas off;

