--+ holdcas on;
set names utf8;
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ja_exp);
  
insert into test_tr values (1,'午後');
insert into test_tr values (2,'午前'); 
insert into test_tr values (3,'午前');
insert into test_tr values (103,'午前');
insert into test_tr values (203,'午前');
insert into test_tr values (303,'午前.西暦');
insert into test_tr values (403,'午前 紀元');
insert into test_tr values (4,'紀元');
insert into test_tr values (104,'ムモ');
insert into test_tr values (5,'西暦'); 
insert into test_tr values (105,'韓国語');
insert into test_tr values (205,'英語'); 
insert into test_tr values (6,'基盤');
insert into test_tr values (106,'%基盤'); 
insert into test_tr values (7,'簡体');
insert into test_tr values (107,'_簡体');
insert into test_tr values (8,'ムモ');
insert into test_tr values (9,'繁体');
insert into test_tr values (109,'?繁体');
insert into test_tr values (10,'中国語');
insert into test_tr values (110,'*中国語');

select id, name, field ('午前',name) from test_tr order by 1;

select id, name, field (name,'ムモ') from test_tr order by 1;


drop table test_tr;

SELECT FIELD('広東語', '広東語','広東語');

SELECT FIELD('広東語', '広東語','広東語');

SELECT FIELD('ズニ語', 'ズニ語族','ズニ語族');
set names iso88591;
commit;
--+ holdcas off;

