--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name    varchar(20) collate utf8_ro_cs);
  
insert into test_ro values (1,'Nu î*şnțe*lşeg');
insert into test_ro values (2,'Nu*îşnțe*şle*g');
insert into test_ro values (3,'Nu?ş*şşşîşnțe*leg***');
insert into test_ro values (4,'*Nu înş*şțeşl*eşg*');
insert into test_ro values (5,null);

--test
select id, name, substring_index(name,'*',2) from test_ro order by 1;
--test
select id, name, substring_index(name,'*', 1) from test_ro order by 1;
--test
select id, name, substring_index(name,'**',1) from test_ro order by 1;
--test
select id, name, substring_index(name,'ş', 5) from test_ro order by 1;
--test
select id, name, substring_index(name,'Ş', 2) from test_ro order by 1;
--test
select id, name, substring_index(name,'î',1) from test_ro order by 1;
--test
select id, name, substring_index(name,'ş',3) from test_ro order by 1;
--test
select id, name, substring_index(name,'şş',1) from test_ro order by 1;
--test
select id, name, substring_index(name,'î',-100) from test_ro order by 1;

drop table test_ro;

set names iso88591;
commit;
--+ holdcas off;
