--+ holdcas on;
set names utf8;
CREATE TABLE test_tr ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_tr_cs_uca);
insert into test_tr values (1,'İzgü');
insert into test_tr values (2,'好İzgü');
insert into test_tr values (3,null);
--test
select id, name, LPAD (name,5,'x') from test_tr order by 1;
--test
select id, name, LPAD (name,1,'ı') from test_tr order by 1;
--test
select id, name, LPAD (name,2,'ı') from test_tr order by 1;
--test
select id, name, LPAD (name,10,'2ı ') from test_tr order by 1;
--test
select id, name, LPAD (name,null,'2ı ') from test_tr order by 1;
--test
select id, name, LPAD (name,10,null) from test_tr order by 1;

--test
select id, name, RPAD (name,5,'x') from test_tr order by 1;
--test
select id, name, RPAD (name,1,'ı') from test_tr order by 1;
--test
select id, name, RPAD (name,2,'ı') from test_tr order by 1;
--test
select id, name, RPAD (name,10,'2ı ') from test_tr order by 1;
--test
select id, name, RPAD (name,null,'2ı ') from test_tr order by 1;
--test
select id, name, RPAD (name,10,null) from test_tr order by 1;

drop table test_tr;

set names iso88591;
commit;
--+ holdcas off;
