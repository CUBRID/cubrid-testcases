--+ holdcas on;
set names utf8;
CREATE TABLE test_cn ( 
  id     int    NOT NULL, 
  name      CHAR(20) collate utf8_gen);
  
insert into test_cn values (1,'工洼垃鹅嗯');
insert into test_cn values (2,'工洼垃鹅人'); 
insert into test_cn values (3,'火咱工哎');
insert into test_cn values (103,'火咱工哎');
insert into test_cn values (203,'火咱工蛤');
insert into test_cn values (303,'火咱工蛤.火咱咱鹅他她火嗯');
insert into test_cn values (403,'火咱工哎 蛤谢谢鹅他他火嗯');
insert into test_cn values (4,'火咱弓洼');
insert into test_cn values (104,'蛤咱弓洼');
insert into test_cn values (5,'火咱咱鹅他她火嗯'); 
insert into test_cn values (105,'蛤我我鹅他他火嗯');
insert into test_cn values (205,'蛤工工鹅他他火嗯'); 
insert into test_cn values (6,'尚洼开人啊嗯');
insert into test_cn values (106,'%尚洼开人啊嗯'); 
insert into test_cn values (7,'尚洼开人啊嗯');
insert into test_cn values (107,'_尚洼开人啊嗯');
insert into test_cn values (8,'蛤咱弓洼');
insert into test_cn values (9,'火垃哈啊嗯');
insert into test_cn values (109,'?火垃哈啊嗯');
insert into test_cn values (10,'火咱工澳');
insert into test_cn values (110,'*火咱工澳');

select id,name from test_cn where name between '工洼垃鹅人' and '火咱弓洼   ' order by 1;

select id,name from test_cn where name between '火咱工蛤. ' and '_  ' order by 1;

select id,name from test_cn where name between ' .' and '火咱工蛤   ' order by 1;

drop table test_cn;
set names iso88591;
commit;
--+ holdcas off;