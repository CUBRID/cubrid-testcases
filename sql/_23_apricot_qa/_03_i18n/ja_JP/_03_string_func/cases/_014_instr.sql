--+ holdcas on;
set names utf8;
CREATE TABLE test_jp ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ja_exp);
insert into test_jp values (1,'午後');
insert into test_jp values (2,'午前'); 
insert into test_jp values (3,'午前');
insert into test_jp values (103,'午前');
insert into test_jp values (203,'午前');
insert into test_jp values (303,'午前.西暦');
insert into test_jp values (403,'午前 紀元');
insert into test_jp values (4,'紀元');
insert into test_jp values (104,'ムモ');
insert into test_jp values (5,'西暦'); 
insert into test_jp values (105,'韓国語');
insert into test_jp values (205,'いイ'); 
insert into test_jp values (6,'基盤');
insert into test_jp values (106,'%基盤'); 
insert into test_jp values (7,'簡体');
insert into test_jp values (107,'_簡体');
insert into test_jp values (8,'ムモ');
insert into test_jp values (9,'繁体');
insert into test_jp values (109,'?繁体');
insert into test_jp values (10,'中国語');
insert into test_jp values (110,'*中国語');

select id, name, instr (name,'午',1) from test_jp order by 1;

select id, name, instr (name,'午',2) from test_jp order by 1;

select id, name, instr (name,'前.西',2) from test_jp order by 1;

select id, name, instr (name,'*中',-1) from test_jp order by 1;

drop table test_jp;


select instr ('午後','後',1);

select instr ('午後','後',2);

select instr ('午後','後',3);

select instr ('午前.西暦','前.西',1);

select instr ('午前.西暦','前.西',2);

select instr ('午前.西暦','前.西',3);

select instr ('午前.西暦','前.西',4);

select instr ('午後','午',-1);

select instr ('午後','午',-4);

select instr ('午後','午',-5);

select instr ('午前.西暦','前.西',-1);

select instr ('午前.西暦','前.西',-2);

select instr ('午前.西暦','前.西',-3);
set names iso88591;
commit;
--+ holdcas off;

