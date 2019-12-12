--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(50) collate utf8_ro_cs);
insert into test_ro values (1,'Îmi pare bine de cunoștință');
insert into test_ro values (2,'Îți doresc / Vă doresc o zi plăcută!'); 
insert into test_ro values (3,'Însănătoșire grabnică!');
insert into test_ro values (4,'Multă sănătate');
insert into test_ro values (5,null);

--test
select id, name, reverse (name) from test_ro order by 1;
--test
select 'De ce râdeți?' collate utf8_ro_cs, reverse('De ce râdeți?' collate utf8_ro_cs);

drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;
