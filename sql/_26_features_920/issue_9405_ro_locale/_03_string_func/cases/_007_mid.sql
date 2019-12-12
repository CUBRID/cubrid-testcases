--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ro_cs);
  
insert into test_ro values (1, 'Scuzați-mă!');
insert into test_ro values (2, 'Cât costă?');
insert into test_ro values (3, null);

--test
select id, name, mid (name,1,2) from test_ro order by 1;
select id, name, mid (name,5,2) from test_ro order by 1;
select id, name, mid (name,2,9) from test_ro order by 1;
select id, name, mid (name,8,12) from test_ro order by 1;
select id, name, mid (name,-6,12) from test_ro order by 1;
select id, name, mid (name,-4,4) from test_ro order by 1;
--test
select id, name, mid (name,1,0) from test_ro order by 1;
--test
select id, name, mid (name,1,100) from test_ro order by 1;
--test
select id, name, mid (name,1,null) from test_ro order by 1;
--test
select id, name, mid(right (left(name,100),100),4,2) from test_ro order by 1;
drop table test_ro;

set names iso88591;
commit;
--+ holdcas off;
