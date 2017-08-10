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
select id, name, LOCATE ('?Î', name) from test_ro order by 1;
--test
select id, name, LOCATE ('â', name, 2) from test_ro order by 1;
--test
select id, name, LOCATE ('n', name) from test_ro order by 1;
--test
select id, name, LOCATE ('Scu', name) from test_ro order by 1;
--test
select id, name, LOCATE ('știn', name, 10) from test_ro order by 1;
--test
select id, name, LOCATE ('ț', name, -2) from test_ro order by 1;
--test
select id, name, LOCATE (null, name) from test_ro order by 1;
--test
select id, name, LOCATE ('Ș', name) from test_ro order by 1;
--test
select id, name, LOCATE ('ă', name, 0) from test_ro order by 1;


drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;


