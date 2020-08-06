--+ holdcas on;
set names utf8;
CREATE TABLE test_ro ( 
  id     int    NOT NULL, 
  name      VARCHAR(20) collate utf8_ro_cs);
  
insert into test_ro values (1, 'Încântat de cunoștin');
insert into test_ro values (2, 'Bună dimineața');

--test
select id, name, left (name,1) from test_ro order by 1;
select id, name, left (name,8) from test_ro order by 1;
select id, name, left (name,9) from test_ro order by 1;
select id, name, left (name,5) from test_ro order by 1;
--test
select id, name, left (name,null) from test_ro order by 1;
--test
select id, name, left (name,100) from test_ro order by 1;
drop table test_ro;
set names iso88591;
commit;
--+ holdcas off;

