--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(50) collate utf8_ro_cs);
insert into test_ro values (1,'     înțeleg      ');
insert into test_ro values (2,'îîîÎa  gcîî'); 
insert into test_ro values (3,'ĂâĂâĂ123âĂâĂ123âĂâĂâ');
insert into test_ro values (4,'îîîÎagcîîîî');
insert into test_ro values (5,null);

--test
select id, name, trim(name) from test_ro order by 1;
--test
select id, name, trim(null from name) from test_ro order by 1;
--test
select id, name, trim('î' from name) from test_ro order by 1;
--test
select id, name, trim('îî' from name) from test_ro order by 1;
--test
select id, name, trim('Ăâ' from name) from test_ro order by 1;
--test
select id, name, trim(trailing from name) from test_ro order by 1;
--test
select id, name, trim(both 'Ă' from name) from test_ro order by 1;
--test
select id, name, trim(TRAILING 'îî' from name) from test_ro order by 1;
--test
select id, name, ltrim(name,'îîî') from test_ro order by 1;
--test
select id, name, trim(LEADING 'ĂâĂ' from name) from test_ro order by 1;
--test
select id, name, ltrim(name, 'î') from test_ro order by 1;
--test
select id, name, rtrim(name, 'Ăâ') from test_ro order by 1;

drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;

