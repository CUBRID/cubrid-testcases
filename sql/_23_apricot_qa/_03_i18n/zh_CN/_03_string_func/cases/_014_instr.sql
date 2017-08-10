--+ holdcas on;
set names utf8;
CREATE TABLE test_cn ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_gen);
insert into test_cn values (1,'测试');
insert into test_cn values (2,'我们'); 
insert into test_cn values (3,'我们');
insert into test_cn values (103,'我们');
insert into test_cn values (203,'我们');
insert into test_cn values (303,'我们.国家');
insert into test_cn values (403,'我们 生活');
insert into test_cn values (4,'生活');
insert into test_cn values (104,'高兴');
insert into test_cn values (5,'国家'); 
insert into test_cn values (105,'你们好');
insert into test_cn values (205,'可不'); 
insert into test_cn values (6,'可以');
insert into test_cn values (106,'%可以'); 
insert into test_cn values (7,'汽车');
insert into test_cn values (107,'_汽车');
insert into test_cn values (8,'高兴');
insert into test_cn values (9,'话剧');
insert into test_cn values (109,'?话剧');
insert into test_cn values (10,'程序员');
insert into test_cn values (110,'*程序员');

select id, name, instr (name,'我',1) from test_cn order by 1;

select id, name, instr (name,'可',1) from test_cn order by 1;

select id, name, instr (name,'们.国',2) from test_cn order by 1;

select id, name, instr (name,'发展') from test_cn order by 1;

drop table test_cn;


select instr ('测试','试',1);

select instr ('测试','试',2);

select instr ('测试','试',3);

select instr ('我们.国家','们.国',1);

select instr ('我们.国家','们.国',2);

select instr ('我们.国家','们.国',3);

select instr ('我们.国家','们.国',4);

select instr ('测试','测',-1);

select instr ('测试','测',-4);

select instr ('测试','测',-5);

select instr ('我们.国家','们.国',-1);

select instr ('我们.国家','们.国',-8);

select instr ('我们.国家','们.国',-9);
set names iso88591;
commit;
--+ holdcas off;


