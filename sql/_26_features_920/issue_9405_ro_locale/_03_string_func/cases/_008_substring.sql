--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name    varchar(20) collate utf8_ro_cs);
  
insert into test_ro values (1,'Nu înțeleg');
insert into test_ro values (2,'Nuînțeleg');
insert into test_ro values (3,'Nu?înțeleg');
insert into test_ro values (4,'*Nu înțeleg*');
insert into test_ro values (5,null);

--test
select id, name, substring(name,1,3) from test_ro order by 1;
--test
select id, name, substring(name,0) from test_ro order by 1;
--test
select id, name, substring(name,-3) from test_ro order by 1;
select id, name, substr(name,-3) from test_ro order by 1;
--test
select id, name, substring(name,-5,3) from test_ro order by 1;
select id, name, substr(name,-5,3) from test_ro order by 1;
--test
select id, name, substring(name,null,2) from test_ro order by 1;
--test
select id, name, substring(name,-3,null) from test_ro order by 1;
select id, name, substr(name,-3,null) from test_ro order by 1;
drop table test_ro;

set names iso88591;
commit;
--+ holdcas off;
