--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ro_cs);
insert into test_ro values (1,'CAt');
insert into test_ro values (2,'Cât'); 
insert into test_ro values (3,'Cat');
insert into test_ro values (4,'Căt');
insert into test_ro values (5,null);

--test
select id, name, strcmp (name, upper(name)) from test_ro order by 1;
--test
select id, name, strcmp (name, lower(name)) from test_ro order by 1;
--test
select id, name, strcmp (name, 'Cât') from test_ro order by 1;
--test
select id, name, strcmp (name, 'CÂt') from test_ro order by 1;
--test
select id, name, strcmp (name, 'Căt') from test_ro order by 1;
--test
select id, name, strcmp (name, 'CĂt') from test_ro order by 1;
drop table test_ro;

set names iso88591;
commit;
--+ holdcas off;
