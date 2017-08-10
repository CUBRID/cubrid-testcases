--normal case: merge into target table using source subquery, merge condition


autocommit off;


--target table
create table target(
	name char(20), 
	id char(20), 
	edate date, 
	email varchar
);

insert into target values('aaa', 'db110', '2000-12-25', 'aaa@db.com');
insert into target values('bbb', 'db118', '2000-12-28', 'bbb@db.com');
insert into target values('ccc', 'db125', '2001-05-25', 'ccc@db.com');
insert into target values('ddd', 'db133', '2001-08-25', 'ddd@db.com');
insert into target values('ddd', 'db141', '2001-09-12', 'dddd@db.com');
insert into target values('eee', 'db142', '2002-03-12', 'eee@db.com');
insert into target values('fff', 'db211', '2002-03-25', 'fff@db.com');
insert into target values('ggg', 'db222', '2005-01-11', 'ggg@db.com');
insert into target values('ggg', 'db231', '2005-02-22', 'gggg@db.com');
insert into target values('hhh', 'db240', '2005-09-18', 'hhh@db.com');


--source table
create table source1(
	noneed1 datetime default SYS_DATETIME,
        name char(20),
        id varchar(10), 
	noneed2 bigint not null,
        edate date,
        email varchar,
	noneed sequence(char(10))
);

--same with target
insert into source1 values(default, 'aaa', 'db110', 100000, '2000-12-25', 'aaa@db.com', {'a', 'b', 'c'});
insert into source1 values(default, 'fff', 'db211', 200000, '2002-03-25', 'fff@db.com', {'a', 'b', 'c'});
--updated, email unchanged
insert into source1 values(default, 'eeee', 'db148', 300000, '2002-04-12', 'eee@db.com', {'a', 'b', 'c'});
insert into source1 values(default, 'gggg', 'db212', 400000, '2002-04-25', 'ggg@db.com', {'a', 'b', 'c'});
--inserted, new email
insert into source1 values(default, 'abc', 'db300', 500000, '2008-12-12', 'abc@db.com', {'a', 'b', 'c'});
insert into source1 values(default, 'bcd', 'db301', 600000, '2008-12-12', 'bcd@db.com', {'a', 'b', 'c'});
insert into source1 values(default, 'cde', 'db333', 700000, '2009-01-01', 'cde@db.com', {'a', 'b', 'c'});
--others, id starting with 'dev'
insert into source1 values(default, 'ccc', 'dev101', 800000, null, null, {'a', 'b', 'c'});
insert into source1 values(default, 'iii', 'dev102', 900000, null, null, {'a', 'b', 'c'});
insert into source1 values(default, 'ccd', 'dev103', 1000000, null, null, {'a', 'b', 'c'});
insert into source1 values(default, 'cce', 'dev104', 2000000, null, null, {'a', 'b', 'c'});


create table source2(
        name char(20),
        id varchar(10),
	num bigint,
        edate date,
	email string
);

--same with target
insert into source2 values('aaa', 'db110', 100000, '2000-12-25', 'aaa@db.com');
insert into source2 values('fff', 'db211', 200000, '2002-03-25', 'fff@db.com');
--updated, email unchanged
insert into source2 values('eeee', 'db148', 300000, '2002-04-12', 'eee@db.com');
insert into source2 values('ggg', 'db212', 400000, '2002-04-25', 'ggg@db.com');
--inserted, new email
insert into source2 values('abc', 'db300', 500000, '2008-12-12', 'abc@db.com');
insert into source2 values('zzz', 'db301', 600000, '2008-12-12', 'bcd@db.com');
insert into source2 values('cde', 'db333', 700000, '2009-01-01', 'cde@db.com');
--others, id starting with 'dev'
insert into source2 values('ccc', 'dev101', 800000, null, null);
insert into source2 values('cce', 'dev104', 2000000, null, null);
commit;


-- ########################## CUBRID BUG: CUBRIDSUS-9158 ##############################
--TEST: joined results as source
merge into target t
using (select s.name, s.id, s.edate, s.email from source1 s left outer join target t on s.email=t.email where s.name < 'zzz' and s.noneed2 < 1000000 and noneed={'a', 'b', 'c'}) s
on t.email = s.email
when matched then
update set t.name = s.name, t.edate = s.edate, t.id = s.id
when not matched then
insert (t.id, t.edate)
values(s.id, s.edate);
--TEST: check merge result
select if(count(*)=15, 'ok', 'nok') from target order by email;
rollback;


--TEST: with group by in source 
merge into target t
using (select s.name, s.id, s.edate, s.email from source1 s left outer join target t on s.email=t.email where s.name < 'zzz' and s.noneed2 < 1000000 and noneed={'a', 'b', 'c'} group by s.name, s.id, s.edate, s.email, t.email) s
on t.email = s.email
when matched then 
update set t.name = s.name, t.edate = s.edate, t.id = s.id
delete where t.name < 'ddd'
when not matched then
insert (t.id, t.edate)
values(s.id, s.edate);
--TEST: check merge result
select if(count(*)=14, 'ok', 'nok') from target order by email;
rollback;


--TEST: with subquery in source
merge into target t
using (select (select s2.name from source2 s2 where s1.name=s2.name) name, s1.id, s1.edate, s1.email from source1 s1) s
on (t.email = s.email)
when matched then
update set t.name='updated'
delete where t.id='db110'
when not matched then
insert
values(s.name, s.id, s.edate, s.email);
--TEST: check merge result
select if(count(*)=3, 'ok', 'nok') from target where name='updated';
select if(count(*)=16, 'ok', 'nok') from target;
select * from target order by email;
rollback;


--TEST: with analytic function in source
merge into target t
using (select s1.name, (select avg(num) over(partition by name order by email) aaa from source2 s2 where s1.name=s2.name) aaa, s1.id, s1.edate, s1.email from source1 s1) s
on (t.email = s.email)
when matched then
update
set t.name = 'updated', t.id = cast(s.aaa as varchar), t.edate = s.edate
where t.id = s.id
delete where t.id=100000
when not matched then
insert (t.name, t.id)
values('inserted', cast(s.aaa as varchar));
--TEST: check merge result
select if(count(*)=1, 'ok', 'nok') from target where name='updated';
select if(count(*)=16, 'ok', 'nok') from target;
select * from target order by email;
rollback;


--TEST: with not exists
merge into target t
using (select name, id, edate, email from source1 s1 where id like 'db%' and not exists (select avg(num) over(partition by name order by email) aaa from source2 s2 where s1.name=s2.name)) s
on (t.email = s.email)
when matched then
update
set t.name = 'updated', t.id = s.id, t.edate = s.edate
where t.id != s.id
delete where t.id='db211'
when not matched then
insert (t.name, t.id)
values(s.name, s.id);
--TEST: check merge result
select if(count(*)=1, 'ok', 'nok') from target where name='updated';
select if(count(*)=11, 'ok', 'nok') from target;
select * from target order by email;
rollback;


drop table target, source1, source2;
commit;


autocommit on;
                       



