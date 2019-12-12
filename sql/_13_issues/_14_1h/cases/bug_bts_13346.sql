
--+ holdcas on;
drop table if exists test;
create table test (id int , name char(20));
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
 
--good result
update test inner join (values(1),(2)) as t(id) on test.id=t.id set test.id=5 ;
select * from test order by 1 desc,2 desc;
delete from test;
 
insert into test values(1,'name1'),(2,'name2'),(3,'name3'),(4,'name4');
--error result
update test natural join (values(1),(2)) as t(id) set test.id=5 ;
select * from test order by 1 desc,2;
delete from test;

drop table if exists test;
--+ holdcas off;
commit;
