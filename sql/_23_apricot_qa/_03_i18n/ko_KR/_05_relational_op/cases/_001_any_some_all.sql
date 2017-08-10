--+ holdcas on;
set names utf8;
CREATE TABLE test_kr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ko_cs_uca);
  
insert into test_kr values (1,'가각간갈감');
insert into test_kr values (2,'가각간갈강'); 
insert into test_kr values (3,'개객갱갹');
insert into test_kr values (103,'개객갱갹');
insert into test_kr values (203,'십쌍악안');
insert into test_kr values (303,'십쌍악안.과괄광괘광괵괵굉');
insert into test_kr values (403,'개객갱갹 운원월위유육윤율');
insert into test_kr values (4,'입잠장재');
insert into test_kr values (104,'론뢰료룡루');
insert into test_kr values (5,'과괄광괘광괵괵굉'); 
insert into test_kr values (105,'손솔송쇄쇠수숙순');
insert into test_kr values (205,'집징차착찬찰참창'); 
insert into test_kr values (6,'보병별변벽법');
insert into test_kr values (106,'%보병별변벽법'); 
insert into test_kr values (7,'둔둘乧득등락');
insert into test_kr values (107,'_둔둘乧득등락');
insert into test_kr values (8,'론뢰료룡루');
insert into test_kr values (9,'근끽낙김나');
insert into test_kr values (109,'?근끽낙김나');
insert into test_kr values (10,'맹멱면몌');
insert into test_kr values (110,'*맹멱면몌');

select id,name from test_kr where name > ANY {'가각간갈감', '개객갱갹'} order by 1;

select id,name from test_kr where name = ANY {'가각간갈감', '과괄광괘광괵괵굉'} order by 1;


select id,name from test_kr where name < SOME{'가각간갈감', '근끽낙김나'} order by 1;

select id,name from test_kr where name = SOME {'맹멱면몌', ' '} order by 1;


select id,name from test_kr where name >= ALL{'둔둘乧득등락', '론뢰료룡루'} order by 1;

select id,name from test_kr where name <> ALL {'가각간갈감', '과괄광괘광괵괵굉', '개객갱갹', '보병별변벽법'} order by 1;

drop table test_kr;
set names iso88591;
commit;
--+ holdcas off;