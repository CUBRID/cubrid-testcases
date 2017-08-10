--+ holdcas on;
set names utf8;
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20)  collate utf8_tr_cs);
  
insert into test_tr values (1,'Gülen');
insert into test_tr values (2,'Ğüler'); 
insert into test_tr values (3,'你好'); 
insert into test_tr values (4,null); 
insert into test_tr values (4,''); 

--test
select id,name from test_tr where name > ANY {'Gülen', 'İzgi'} order by 1;
--test
select id,name from test_tr where name = ANY {'Gülen', 'İzzettin'} order by 1;

--test
select id,name from test_tr where name < SOME{'Gülen', 'İlhan'} order by 1;
--test
select id,name from test_tr where name = SOME {'你好', ' '} order by 1;

--test
select id,name from test_tr where name >= ALL{'你好', 'İzğü'} order by 1;
--test
select id,name from test_tr where name <> ALL {'Gülen', '你好', 'İzgi', 'SevINÇ'} order by 1;

drop table test_tr;
set names iso88591;
commit;
--+ holdcas off;