--+ holdcas on;
set names utf8;
drop table if exists test_ro;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ro_cs);
  
insert into test_ro values (1,'bună');
insert into test_ro values (2,'bunĂ'); 
insert into test_ro values (3,'bunA');
insert into test_ro values (103,'râdeȚi');
insert into test_ro values (203,'râdeți');
insert into test_ro values (303,'râdeȚi.B');
insert into test_ro values (403,'râdețixxettin');
insert into test_ro values (4,'întîlnim');
insert into test_ro values (104,'întilnim');
insert into test_ro values (5,'întîlnin'); 
insert into test_ro values (105,'Întîlnim');
insert into test_ro values (205,'înțîlnim'); 
insert into test_ro values (6,'oră');
insert into test_ro values (106,'%oră'); 
insert into test_ro values (7,'Oră');
insert into test_ro values (107,'_orÂ');
insert into test_ro values (8,'_bună');
insert into test_ro values (9,'*râdeți');
insert into test_ro values (109,'?întîlnim');
insert into test_ro values (10,'oră*');
insert into test_ro values (110,'râdeȚi?');
--Test
select id, name, field ('bună',name) from test_ro order by 1;
--Test
select id, name, field (null,name) from test_ro order by 1;
--Test
select id, name, field (name,'râdeți') from test_ro order by 1;
--Test
select id, name, field (name,'întîlnim',null) from test_ro order by 1;
--Test
select id, name, field ('oră', name, 'Oră', name) from test_ro order by 1;
--Test
select id, name, field (name, 'bunĂ', 'bună', 'bunA', '_bună') from test_ro order by 1;

drop table test_ro;
--Test
SELECT FIELD('Sînt', 'SînT', 'SÎnt', 'Sînt' collate utf8_ro_cs, 'Sînt?');
--Test
SELECT FIELD('Sînt', 'SînT', to_char('SînȚ'), 'Sînt' collate utf8_ro_cs, 'sînt?');
--Test
SELECT FIELD('Sînt', '%Sînt', 'Sînt1', '*Sînt*', 'Sînt');
--Test
SELECT FIELD('Sînt' collate utf8_ro_cs, 'S', 'Sî', null, 'Sînt', 'Sîn');
--Test
SELECT FIELD(123, '123Sînt','Sînt','123', 'S123înt');
set names iso88591;
commit;
--+ holdcas off;
