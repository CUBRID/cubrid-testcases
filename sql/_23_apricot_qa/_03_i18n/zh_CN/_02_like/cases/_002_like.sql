--+ holdcas on;
set names utf8;
CREATE TABLE t_like ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_gen); 

insert into t_like values (1,'草原吗？');
insert into t_like values (2,'草原喔'); 
insert into t_like values (3,'福建武夷山');
insert into t_like values (103,'福建武夷山');
insert into t_like values (203,'福建武夷山');
insert into t_like values (303,'福建武夷山.秀美壮丽');
insert into t_like values (403,'福建武夷山 秀美壮丽');
insert into t_like values (4,'西安兵马俑');
insert into t_like values (5,'秀美壮丽'); 
insert into t_like values (6,'黄河长江松花江衡水');
insert into t_like values (106,'%黄河长江松花江衡水'); 
insert into t_like values (7,'早安');
insert into t_like values (107,'_早安');
insert into t_like values (8,'蓝天');
insert into t_like values (108,'!蓝天');
insert into t_like values (9,'蓝天');
insert into t_like values (109,'?蓝天');
insert into t_like values (10,'蓝天');
insert into t_like values (110,'*蓝天');

select * from t_like where name like '草原%' order by 1;
select * from t_like where name like '福建武夷_' order by 1;
select * from t_like where name like '福建武夷_' order by 1;
select * from t_like where name like '福建武夷山%' order by 1;
select * from t_like where name like '_建%' order by 1;
select * from t_like where name like '%安' order by 1;
select * from t_like where name like '秀美%' order by 1;
select * from t_like where name like '草原_' order by 1;
select * from t_like where name like '草原__' order by 1;
select * from t_like where name like '草原%' order by 1;

select * from t_like where name like 'ı%黄河长江松花江衡水' escape 'ı'  order by 1;
select * from t_like where name like 'ı%黄河长江_' escape 'ı'  order by 1;

select * from t_like where name like '\%黄河长江松花江衡水' escape '\'  order by 1;
select * from t_like where name like '\%黄河长江_衡_' escape '\'  order by 1;
select * from t_like where name like '\_%' escape '\' order by 1;

select * from t_like where name like '!%'  order by 1;
select * from t_like where name like '?%'  order by 1;
select * from t_like where name like '*%'  order by 1;

drop class t_like;
set names iso88591;
commit;
--+ holdcas off;
