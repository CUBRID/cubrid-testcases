--+ holdcas on;
set names utf8;
--test
select insert('cunoștință',0,1,'ă');
--test
select insert('cunoștință',5,3,' Bună ');


create table test_ro(id int, name varchar(20) collate utf8_ro_cs);
insert into test_ro values(1, 'cunoștință');

--test
select insert(name,-1,10,'ȚȚȚ') from test_ro order by 1;
--test
select insert(name,2,-2,'țțț') from test_ro order by 1;
--test
select insert(name,2,6,'î') from test_ro order by 1;
--test
select insert(name,2,1,'ȚȚȚ') from test_ro order by 1;
--test
select insert(name,2,7,'țțț') from test_ro order by 1;
--test
select insert(name,7,100,'ȚȚȚ') from test_ro order by 1;
--test
select insert(name,2,5,'țțț') from test_ro order by 1;
--test
select insert(name,3,0,null) from test_ro order by 1;
--test
select insert(name,3,-1,null) from test_ro order by 1;
--test
select insert('',1,1,name) from test_ro order by 1;


drop table test_ro;

set names iso88591;
commit;
--+ holdcas off;
