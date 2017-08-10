--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      enum('Nu înțeleg', 'Bună ziua', 'Îți') collate utf8_ro_cs);
insert into test_ro values (1,2);
insert into test_ro values (2,'Îți');
insert into test_ro values (3,1);

--test
select id, name, LPAD (name,5,'x') from test_ro order by 1;
--test
select id, name, LPAD (name,1,'î') from test_ro order by 1;
--test
select id, name, LPAD (name,15,'Șâ') from test_ro order by 1;
--test
select id, name, LPAD (name,10,'2ıĂ ') from test_ro order by 1;
--test
select id, name, LPAD (name,100,'2ĂâÎț오') from test_ro order by 1;
--test
select id, name, LPAD (name,null,'2a') from test_ro order by 1;
--test
select id, name, LPAD (name,10,null) from test_ro order by 1;
--test
select id, name, LPAD (name,-1,'â') from test_ro order by 1;


--test
select id, name, RPAD (name,5,'x') from test_ro order by 1;
--test
select id, name, RPAD (name,1,'î') from test_ro order by 1;
--test
select id, name, RPAD (name,15,'Șâ') from test_ro order by 1;
--test
select id, name, RPAD (name,10,'2ıĂ ') from test_ro order by 1;
--test
select id, name, RPAD (name,100,'2ĂâÎț오') from test_ro order by 1;
--test
select id, name, RPAD (name,null,'2a') from test_ro order by 1;
--test
select id, name, RPAD (name,10,null) from test_ro order by 1;
--test
select id, name, RPAD (name,-1,'â') from test_ro order by 1;



drop table test_ro;

set names iso88591;
commit;
--+ holdcas off;
