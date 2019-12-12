--+ holdcas on;
set names utf8;
CREATE TABLE test_jp ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ja_exp);
  
insert into test_jp values (1,'ぁはァヰン');
insert into test_jp values (2,'ぁはァヰ■'); 
insert into test_jp values (3,'Qdぁ1');
insert into test_jp values (103,'Qdぁ1');
insert into test_jp values (203,'Qdぁ=');
insert into test_jp values (303,'Qdぁ=.Qddヰ亜愛Qン');
insert into test_jp values (403,'Qdぁ1 =師師ヰ亜亜Qン');
insert into test_jp values (4,'Qd発は');
insert into test_jp values (104,'=d発は');
insert into test_jp values (5,'Qddヰ亜愛Qン'); 
insert into test_jp values (105,'卍卍ヰ亜亜Qン');
insert into test_jp values (205,'ぁぁヰ亜亜Qン'); 
insert into test_jp values (6,'麼は樹■沢ン');
insert into test_jp values (106,'%麼は樹■沢ン'); 
insert into test_jp values (7,'麼は樹■沢ン');
insert into test_jp values (107,'_麼は樹■沢ン');
insert into test_jp values (8,'=d発は');
insert into test_jp values (9,'Qァ遠沢ン');
insert into test_jp values (109,'?Qァ遠沢ン');
insert into test_jp values (10,'Qdぁ實');
insert into test_jp values (110,'*Qdぁ實');

select id,name from test_jp where name > ANY {'ぁはァヰン', 'Qdぁ1'} order by 1;

select id,name from test_jp where name = ANY {'ぁはァヰン', 'Qddヰ亜愛Qン'} order by 1;


select id,name from test_jp where name < SOME{'ぁはァヰン', 'Qァ遠沢ン'} order by 1;

select id,name from test_jp where name = SOME {'Qdぁ實', ' '} order by 1;


select id,name from test_jp where name >= ALL{'麼は樹■沢ン', '=d発は'} order by 1;

select id,name from test_jp where name <> ALL {'ぁはァヰン', 'Qddヰ亜愛Qン', 'Qdぁ1', '麼は樹■沢ン'} order by 1;

drop table test_jp;
set names iso88591;
commit;
--+ holdcas off;