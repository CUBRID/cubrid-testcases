--+ holdcas on;

set names utf8;
create table t (col1 varchar(10) utf8_ja_exp not null, col2 utf8_ja_exp varchar(10)); 
INSERT INTO t  VALUES('ぁ', UPPER(' ', 'ぁ'));
INSERT INTO t  VALUES('ぃ', UPPER(' ', 'ぃ'));
INSERT INTO t  VALUES('ぇ', UPPER(' ', 'ぇ'));
INSERT INTO t  VALUES('ぉ', UPPER(' ', 'ぉ'));
INSERT INTO t  VALUES('ゃ', UPPER(' ', 'ゃ'));
INSERT INTO t  VALUES('ん', UPPER(' ', 'ん'));
-- TR chars              
INSERT INTO t  VALUES('ç', UPPER(' ', 'ç'));
INSERT INTO t  VALUES('ğ', UPPER(' ', 'ğ'));
INSERT INTO t  VALUES('ı', UPPER(' ', 'ı'));
INSERT INTO t  VALUES('i', UPPER(' ', 'i'));
INSERT INTO t  VALUES('ö', UPPER(' ', 'ö'));
INSERT INTO t  VALUES('ş', UPPER(' ', 'ş'));
INSERT INTO t  VALUES('ü', UPPER(' ', 'ü'));
-- CN chars              
INSERT INTO t  VALUES('ē', UPPER(' ', 'ē'));
INSERT INTO t  VALUES('ǎ', UPPER(' ', 'ǎ'));
INSERT INTO t  VALUES('Ā', UPPER(' ', 'Ā'));
INSERT INTO t  VALUES('Ń', UPPER(' ', 'Ń'));
INSERT INTO t  VALUES('ǖ', UPPER(' ', 'ǖ'));
INSERT INTO t  VALUES('Ǘ', UPPER(' ', 'Ǘ'));
INSERT INTO t  VALUES('1', UPPER(' ', '1'));
INSERT INTO t  VALUES('0', UPPER(' ', '0'));
INSERT INTO t  VALUES('9', UPPER(' ', '9'));
INSERT INTO t  VALUES('語',UPPER(' ', '語'));
INSERT INTO t  VALUES('1',UPPER(' ', '1'));
INSERT INTO t  VALUES('亜',UPPER(' ', '亜'));
INSERT INTO t  VALUES('■',UPPER(' ', '■'));
INSERT INTO t  VALUES('○',UPPER(' ', '○'));
INSERT INTO t  VALUES('韓',UPPER(' ', '韓'));
INSERT INTO t  VALUES('帀',UPPER(' ', '帀'));


create index idx on t (col1, col2); 

--test
select * from t order by col1; 
--test
select * from t using index none order by col1 desc; 

drop t;
set names iso88591;

commit;
--+ holdcas off;


