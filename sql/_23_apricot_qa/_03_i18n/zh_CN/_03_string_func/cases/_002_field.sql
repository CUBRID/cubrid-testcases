--+ holdcas on;
set names utf8;
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_gen);
  
insert into test_tr values (1,'测试');
insert into test_tr values (2,'我们'); 
insert into test_tr values (3,'我们');
insert into test_tr values (103,'我们');
insert into test_tr values (203,'我们');
insert into test_tr values (303,'我们.国家');
insert into test_tr values (403,'我们 生活');
insert into test_tr values (4,'生活');
insert into test_tr values (104,'高兴');
insert into test_tr values (5,'国家'); 
insert into test_tr values (105,'你们好');
insert into test_tr values (205,'今天'); 
insert into test_tr values (6,'明天');
insert into test_tr values (106,'%明天'); 
insert into test_tr values (7,'汽车');
insert into test_tr values (107,'汽车');
insert into test_tr values (8,'高兴');
insert into test_tr values (9,'科学');
insert into test_tr values (109,'?科学');
insert into test_tr values (10,'程序员');
insert into test_tr values (110,'*程序员');

select id, name, field ('我们',name) from test_tr order by 1;

select id, name, field (name,'高兴') from test_tr order by 1;


drop table test_tr;

SELECT FIELD('大家好', '大家好','大家好');

SELECT FIELD('大家好', '大家好','大家好');

SELECT FIELD('一蹴而', '一蹴而就','一蹴而就');
set names iso88591;
commit;
--+ holdcas off;


