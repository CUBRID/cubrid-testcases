--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(30) collate utf8_ro_cs);
insert into test_ro values (1,'Încântat de cunoștință');
insert into test_ro values (2,'?Încântat de cunoștință'); 
insert into test_ro values (3,'Scuzați-mă!');
insert into test_ro values (4,'Scuzați-mă!?');
insert into test_ro values (5,null);

--test
select id, name, POSITION('?Î' in name) from test_ro order by 1;
--test
select id, name, POSITION('â' in name) from test_ro order by 1;
--test
select id, name, POSITION('n' in name) from test_ro order by 1;
--test
select id, name, POSITION('-' in name) from test_ro order by 1;
--test
select id, name, POSITION('știn' in name) from test_ro order by 1;
--test
select id, name, POSITION('ț' in name) from test_ro order by 1;
--test
select id, name, POSITION(null in name) from test_ro order by 1;
--test
select id, name, POSITION(lower('Ș') in name) from test_ro order by 1;
--test  not supported in CUBRID, not sure if it is a bug
select upper('ș'), lower('Ș');

drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;


