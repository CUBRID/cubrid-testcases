--normal case: merge into source table using source subquery, merge condition


autocommit off;


--source table
create table source(
	name char(20), 
	id char(20), 
	edate date, 
	email varchar
);

insert into source values('aaa', 'db110', '2000-12-25', 'aaa@db.com');
insert into source values('bbb', 'db118', '2000-12-28', 'bbb@db.com');
insert into source values('ccc', 'db125', '2001-05-25', 'ccc@db.com');
insert into source values('ddd', 'db133', '2001-08-25', 'ddd@db.com');
insert into source values('ddd', 'db141', '2001-09-12', 'dddd@db.com');
insert into source values('eee', 'db142', '2002-03-12', 'eee@db.com');
insert into source values('fff', 'db211', '2002-03-25', 'fff@db.com');
insert into source values('ggg', 'db222', '2005-01-11', 'ggg@db.com');
insert into source values('ggg', 'db231', '2005-02-22', 'gggg@db.com');
insert into source values('hhh', 'db240', '2005-09-18', 'hhh@db.com');


--source table
create table target1(
	noneed1 datetime default SYS_DATETIME,
        name char(20),
        id varchar(10), 
	noneed2 bigint not null,
        edate date,
        email varchar,
	noneed sequence(char(10))
);

--same with source
insert into target1 values(default, 'aaa', 'db110', 100000, '2000-12-25', 'aaa@db.com', {'a', 'b', 'c'});
insert into target1 values(default, 'fff', 'db211', 200000, '2002-03-25', 'fff@db.com', {'a', 'b', 'c'});
--updated, email unchanged
insert into target1 values(default, 'eeee', 'db148', 300000, '2002-04-12', 'eee@db.com', {'a', 'b', 'c'});
insert into target1 values(default, 'gggg', 'db212', 400000, '2002-04-25', 'ggg@db.com', {'a', 'b', 'c'});
--inserted, new email
insert into target1 values(default, 'abc', 'db300', 500000, '2008-12-12', 'abc@db.com', {'a', 'b', 'c'});
insert into target1 values(default, 'bcd', 'db301', 600000, '2008-12-12', 'bcd@db.com', {'a', 'b', 'c'});
insert into target1 values(default, 'cde', 'db333', 700000, '2009-01-01', 'cde@db.com', {'a', 'b', 'c'});
--others, id starting with 'dev'
insert into target1 values(default, 'ccc', 'dev101', 800000, null, null, {'a', 'b', 'c'});
insert into target1 values(default, 'iii', 'dev102', 900000, null, null, {'a', 'b', 'c'});
insert into target1 values(default, 'ccd', 'dev103', 1000000, null, null, {'a', 'b', 'c'});
insert into target1 values(default, 'cce', 'dev104', 2000000, null, null, {'a', 'b', 'c'});


create table target2(
        name char(20),
        id varchar(10),
	num bigint,
        edate date,
	email string
);

--same with source
insert into target2 values('aaa', 'db110', 100000, '2000-12-25', 'aaa@db.com');
insert into target2 values('fff', 'db211', 200000, '2002-03-25', 'fff@db.com');
--updated, email unchanged
insert into target2 values('eeee', 'db148', 300000, '2002-04-12', 'eee@db.com');
insert into target2 values('ggg', 'db212', 400000, '2002-04-25', 'ggg@db.com');
--inserted, new email
insert into target2 values('abc', 'db300', 500000, '2008-12-12', 'abc@db.com');
insert into target2 values('zzz', 'db301', 600000, '2008-12-12', 'bcd@db.com');
insert into target2 values('cde', 'db333', 700000, '2009-01-01', 'cde@db.com');
--others, id starting with 'dev'
insert into target2 values('ccc', 'dev101', 800000, null, null);
insert into target2 values('cce', 'dev104', 2000000, null, null);
commit;


--TEST: [er] joined results as target
merge into (select s.name, s.id, s.edate, s.email from target1 s left outer join source t on s.email=t.email where s.name < 'zzz' and s.noneed2 < 1000000 and noneed={'a', 'b', 'c'}) t 
using source s
on t.email = s.email
when matched then
update set t.name = s.name, t.edate = s.edate, t.id = s.id
when not matched then
insert (t.id, t.edate)
values(s.id, s.edate);

create view v as select s.name, s.id, s.edate, s.email from target1 s left outer join source t on s.email=t.email where s.name < 'zzz' and s.noneed2 < 1000000 and noneed={'a', 'b', 'c'};
merge into v t
using source s
on t.email = s.email
when matched then
update set t.name = s.name, t.edate = s.edate, t.id = s.id
when not matched then
insert (t.id, t.edate)
values(s.id, s.edate);

rollback;

--TEST: [er] with group by in target
create view v as select s.name, s.id, s.edate, s.email from target1 s left outer join source t on s.email=t.email where s.name < 'zzz' and s.noneed2 < 1000000 and noneed={'a', 'b', 'c'} group by s.name, s.id, s.edate, s.email;
merge into v t
using source s
on t.email = s.email
when matched then 
update set t.name = s.name, t.edate = s.edate, t.id = s.id
delete where t.name < 'ddd'
when not matched then
insert (t.id, t.edate)
values(s.id, s.edate);

rollback;

--TEST: [er] with subquery in target
create view v as select (select s2.name from target2 s2 where s1.name=s2.name) name, s1.id, s1.edate, s1.email from target1 s1;
merge into v t
using source s
on (t.email = s.email)
when matched then
update set t.name='updated'
delete where t.id='db110'
when not matched then
insert
values(s.name, s.id, s.edate, s.email);
--TEST: check merge result
select * from source order by email;
rollback;


--TEST: [er] with analytic function in target
create view v as select s1.name, (select avg(num) over(partition by name order by email) aaa from target2 s2 where s1.name=s2.name) aaa, s1.id, s1.edate, s1.email from target1 s1;
merge into v t
using source s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id, t.edate = s.edate
where t.id != s.id
delete where t.id='db211'
when not matched then
insert (t.name, t.id)
values(s.name, s.id);
--TEST: check merge result
select * from source order by email;
rollback;


--TEST: [er] with not exists
create view v as select name, id, edate, email from target1 s1 where id like 'db%' and not exists (select avg(num) over(partition by name order by email) aaa from target2 s2 where s1.name=s2.name);
merge into v t 
using source s
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
select * from source order by email;
rollback;


drop table source, target1, target2;
commit;


autocommit on;
                       



