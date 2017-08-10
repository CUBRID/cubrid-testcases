--test with inheritance: merge into a super/sub class


autocommit off;

--create super class
create table sup(id smallint, col1 bigint not null);
insert into sup values(2, 5), (4, 10), (6, 13), (8, 22), (10, 45), (12, 57);

--create sub class
create table sub under sup(col2 char(50));
insert into sub values(6, 111, 'aaa'), (10, 111, 'bbb'), (11, 222, 'abc'), (44, 222, 'efg');

commit;


--TEST: merge into super class using sub class
merge into sup p
using sub b
on (p.id=b.id)
when matched then
update
set p.col1=b.col1
when not matched then 
insert
values(b.id, b.col1);

select if (count(*) = 4, 'ok', 'nok') from sup where col1 in (111, 222);

rollback;


--TEST: merge into the sub class using the super class, 4 rows merged.
merge into sub b
using sup p
on (b.id=p.id)
when matched then
update
set b.col1=p.col1
where p.id < 10
when not matched then
insert
values(p.id, p.col1, 'inserted')
where p.id < 10;

select if (col1 = 13, 'ok', 'nok') from sub where id=6;
select if (count(*) = 3, 'ok', 'nok') from sub where col2='inserted';

rollback;


--TEST: merge into the sub class using another table
create table tt(id smallint primary key, col1 char(20));
insert into tt values(1, 'inserted'), (2, 'updated'), (3, 'inserted'), (4, 'updated'), (5, 'inserted'), (6, 'updated');
insert into tt values(7, 'inserted'), (8, 'updated'), (9, 'inserted'), (10, 'updated'), (11, 'inserted'), (12, 'updated');

--add pk to the super table
delete from sub where id <= 10;
alter table sup add constraint primary key(id);
alter table sup add column col3 varchar;

--TEST: error, not null constraint violation error, merge into super table
merge into sup p
using tt t
on (p.id=t.id)
when matched then
update
set p.col3=t.col1
when not matched then
insert(p.id, p.col3)
values(t.id, t.col1);

--TEST: check the result
select if (count(*)=0, 'ok', 'nok') from sup where col3 in ('updated', 'inserted');


--TEST: error, pk constraint violation error, merge into the super table
merge into sup p
using tt t
on (p.id=t.id)
when matched then
update
set p.col3=t.col1
when not matched then
insert(p.id, p.col1, p.col3)
values(t.id, t.id, t.col1);

--TEST: check the result
select if (count(*)=0, 'ok', 'nok') from sup where col3 in ('updated', 'inserted');


--TEST: success, 12 rows merged.
delete from sub where id=11;

merge into sup p
using tt t
on (p.id=t.id)
when matched then
update
set p.col3=t.col1
when not matched then
insert(p.id, p.col1, p.col3)
values(t.id, 999, t.col1);

select if (count(*)=6, 'ok', 'nok') from sup where col3='updated';
select if (count(*)=6, 'ok', 'nok') from sup where col3='inserted';

rollback;



drop table sup, sub;
commit;


autocommit on;


