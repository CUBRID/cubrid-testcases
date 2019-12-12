--+ holdcas on;
set names utf8;
CREATE TABLE t ( 
  col1     int    NOT NULL, 
  col2      VARCHAR(20) collate utf8_ja_exp);
  
insert into t values (1,'ぁはァヰン');
insert into t values (2,'ぁはァヰ■'); 
insert into t values (3,'Qdぁ1');
insert into t values (103,'Qdぁ1');
insert into t values (203,'Qdぁ=');
insert into t values (303,'Qdぁ=.Qddヰ亜愛Qン');
insert into t values (403,'Qdぁ1 蛤谢谢鹅他他火嗯');
insert into t values (4,'Qd発は');
insert into t values (104,'=d発は');
insert into t values (5,'Qddヰ亜愛Qン'); 
insert into t values (105,'卍卍ヰ亜亜Qン');
insert into t values (205,'ぁぁヰ亜亜Qン'); 
insert into t values (6,'麼は樹■沢ン');
insert into t values (106,'%麼は樹■沢ン'); 
insert into t values (7,'麼は樹■沢ン');
insert into t values (107,'_麼は樹■沢ン');
insert into t values (8,'=d発は');
insert into t values (9,'Qァ遠沢ン');
insert into t values (109,'?Qァ遠沢ン');
insert into t values (10,'Qdぁ實');
insert into t values (110,'*Qdぁ實');

--test
select * from t order by col2;
--test
select * from t order by col2 desc;

drop table t;
set names iso88591;
commit;
--+ holdcas off;