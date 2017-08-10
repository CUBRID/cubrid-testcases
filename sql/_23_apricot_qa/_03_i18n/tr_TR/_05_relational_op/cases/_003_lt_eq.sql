--+ holdcas on;
set names utf8;
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      CHAR(20)  collate utf8_tr_cs);
  
insert into test_tr values (1,'Gülen');
insert into test_tr values (2,'Ğüler'); 
insert into test_tr values (3,'İzgi');
insert into test_tr values (4,'你好');
insert into test_tr values (5,null);

--test
select id,name from test_tr where name < 'İzgi' order by 1;
--test
select id,name from test_tr where name <= 'SevINÇ ' order by 1;
--test
select id,name from test_tr where name <= ' ' order by 1;
--test
select id,name from test_tr where name < 'İz ' order by 1;
--test
select id,name from test_tr where name < '_ ' order by 1;

drop table test_tr;
set names iso88591;
commit;
--+ holdcas off;