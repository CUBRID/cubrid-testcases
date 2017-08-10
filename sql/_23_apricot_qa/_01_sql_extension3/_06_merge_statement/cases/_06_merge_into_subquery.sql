--merge into a subquery


autocommit off;


--target table
create table target(
	name char(20), 
	id string,
	noneed1 int, 
	edate date, 
	noneed2 short,
	email varchar
);

insert into target values('aaa', 'db110', 1, '2000-12-25', 123, 'aaa@db.com');
insert into target values('bbb', 'db118', 2, '2000-12-28', 345, 'bbb@db.com');
insert into target values('ccc', 'db125', 3, '2001-05-25', 234, 'ccc@db.com');
insert into target values('ddd', 'db133', 4, '2001-08-25', 344, 'ddd@db.com');
insert into target values('ddd', 'db141', 5, '2001-09-12', 848, 'dddd@db.com');
insert into target values('eee', 'db142', 6, '2002-03-12', 8983, 'eee@db.com');
insert into target values('fff', 'db211', 7, '2002-03-25', 234, 'fff@db.com');
insert into target values('ggg', 'db222', 8, '2005-01-11', 654, 'ggg@db.com');
insert into target values('ggg', 'db231', null, '2005-02-22', 234, 'gggg@db.com');
insert into target values('hhh', 'db240', 9, '2005-09-18', null, 'hhh@db.com');


--source table
create table source_tbl(
	noneed1 datetime default SYS_DATETIME,
        name char(20),
        id string, 
	noneed2 bigint not null,
        edate date,
        email varchar,
	noneed3 sequence(char(10))
);

--same with target
insert into source_tbl values(default, 'aaa', 'db110', 100000, '2000-12-25', 'aaa@db.com', {'a', 'b', 'c'});
insert into source_tbl values(default, 'bbb', 'db118', 200000, '2000-12-28', 'bbb@db.com', {'a', 'b', 'c'});
--updated, email unchanged
insert into source_tbl values(default, 'eeee', 'db148', 300000, '2002-04-12', 'eee@db.com', {'a', 'b', 'c'});
insert into source_tbl values(default, 'ffff', 'db212', 400000, '2002-04-25', 'fff@db.com', {'a', 'b', 'c'});
--inserted, new email
insert into source_tbl values(default, 'abc', 'db300', 500000, '2008-12-12', 'abc@db.com', {'a', 'b', 'c'});
insert into source_tbl values(default, 'bcd', 'db301', 600000, '2008-12-12', 'bcd@db.com', {'a', 'b', 'c'});
insert into source_tbl values(default, 'cde', 'db333', 700000, '2009-01-01', 'cde@db.com', {'a', 'b', 'c'});
--others, id starting with 'dev'
insert into source_tbl values(default, 'ccc', 'dev101', 800000, null, null, {'a', 'b', 'c'});
insert into source_tbl values(default, 'iii', 'dev102', 900000, null, null, {'a', 'b', 'c'});
insert into source_tbl values(default, 'ccd', 'dev103', 1000000, null, null, {'a', 'b', 'c'});
insert into source_tbl values(default, 'cce', 'dev104', 2000000, null, null, {'a', 'b', 'c'});

commit;


--TEST: error, without both update and insert clause
merge into (select name, id, edate, email from target) t
using (select name, id, edate, email from source_tbl where id like 'db%') s
on (t.email = source_vuiew.email);


--TEST: error, with insert clause, without update clause, insert part of the values
merge into (select name, id, edate, email from target) t
using (select name, id, edate, email from source_tbl where id like 'db%') s
on t.email = s.email
when not matched then
insert
values(s.id, s.edate);
--TEST: check merge result
select if(count(*)=10, 'ok', 'nok') from target;

--TEST: error, merge into a derived table error, with update clause, without insert clause
merge into (select name, id, edate, email from target) t
using (select name, id, edate, email from source_tbl where id like 'db%') s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.edate = s.edate, t.id = s.id;
--TEST: check merge result
select if(count(*)=0, 'ok', 'nok') from target where id in ('hhhh', 'eeee');
rollback;


--TEST: error, merge into a derived table error, with insert clause, without update clause
merge into (select name, id, edate, email from target where name < 'ggg') t
using (select name, id, edate, email from source_tbl where id like 'db%') s
on (t.email = s.email)
when not matched then
insert
values(s.name, s.id, s.edate, s.email);
--TEST: check merge result
select if(count(*)=10, 'ok', 'nok') from target;
rollback;


--TEST: error, merge into a derived table error, with update clause with where conditions
merge into (select name, id, edate, email from target where email < 'g') t
using (select name, id, edate, email from source_tbl where id like 'db%') s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id, t.edate = s.edate
where t.id != s.id; 
--TEST: check merge result
select if(count(*)=0, 'ok', 'nok') from target where id in ('hhhh', 'eeee');
rollback;


--TEST: error, merge into a derived table error, with both update and insert clause with where conditions
merge into (select name, id, edate, email from target where edate < '2005-02-22') t
using (select name, id, edate, email from source_tbl where id like 'db%') s
on (t.email = s.email)
when matched then
update
set t.edate = s.edate
where t.id = s.id and t.name = s.name
when not matched then
insert 
values(s.name, s.id, s.edate, s.email)
where year(s.edate) = 2008;
--TEST: check merge result
select if(count(*)=0, 'ok', 'nok') from target where id in ('hhhh', 'eeee');
select if(count(*)=10, 'ok', 'nok') from target;
rollback;


--TEST: with delete clause
merge into (select name, id, edate, email from target where noneed1 < 8) t
using (select name, id, edate, email from source_tbl where id like 'db%') s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id
delete where(t.edate = s.edate)
when not matched then
insert
values(s.name, s.id, s.edate, s.email);
--TEST: check merge result
select if(count(*)=0, 'ok', 'nok') from target where id in ('hhhh', 'eeee');
select if(count(*)=10, 'ok', 'nok') from target;
rollback;



drop table target, source_tbl;
commit;


autocommit on;
                       



