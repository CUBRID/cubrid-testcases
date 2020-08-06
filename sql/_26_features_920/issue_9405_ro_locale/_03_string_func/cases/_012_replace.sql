--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ro_cs);
insert into test_ro values (1,'abc123 ÎțiÂBC');
insert into test_ro values (2,'abc123ÂBCÎțiÂBC'); 
insert into test_ro values (3,'*rsșț?ABC*ÂBC#123');
insert into test_ro values (4,'*rsșț?ABC*ÂBC#123&rs');
insert into test_ro values (5,null);

--test
select id, name, replace (name,'Â','A') from test_ro order by 1;
--test
select id, name, replace (name,'abc',null) from test_ro order by 1;
--test
select id, name, replace (name,'rsșț','RSȘȚ') from test_ro order by 1;
--test
select id, name, replace (name,'ÂBC','Îț') from test_ro order by 1;
--test
select id, name, replace (name,'Â','너') from test_ro order by 1;


drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;


