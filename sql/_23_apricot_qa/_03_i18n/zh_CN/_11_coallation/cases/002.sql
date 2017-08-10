--+ holdcas on;
set names utf8;
CREATE TABLE t ( 
  col1     int    NOT NULL, 
  col2      VARCHAR(20) collate utf8_gen);
  
insert into t values (1,'工洼垃鹅嗯');
insert into t values (2,'工洼垃鹅人'); 
insert into t values (3,'火咱工哎');
insert into t values (103,'火咱工哎');
insert into t values (203,'火咱工蛤');
insert into t values (303,'火咱工蛤.火咱咱鹅他她火嗯');
insert into t values (403,'火咱工哎 蛤谢谢鹅他他火嗯');
insert into t values (4,'火咱弓洼');
insert into t values (104,'蛤咱弓洼');
insert into t values (5,'火咱咱鹅他她火嗯'); 
insert into t values (105,'蛤我我鹅他他火嗯');
insert into t values (205,'蛤工工鹅他他火嗯'); 
insert into t values (6,'尚洼开人啊嗯');
insert into t values (106,'%尚洼开人啊嗯'); 
insert into t values (7,'尚洼开人啊嗯');
insert into t values (107,'_尚洼开人啊嗯');
insert into t values (8,'蛤咱弓洼');
insert into t values (9,'火垃哈啊嗯');
insert into t values (109,'?火垃哈啊嗯');
insert into t values (10,'火咱工澳');
insert into t values (110,'*火咱工澳');

--test
select * from t order by col2;
--test
select * from t order by col2 desc;

drop table t;
set names iso88591;
commit;
--+ holdcas off;