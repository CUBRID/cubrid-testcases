set system parameters 'create_table_reuseoid=no';
--merge into a view with 'WITH CHECK OPTION'


autocommit off;


--target table
create table target(
	name char(20), 
	id varchar(10), 
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

--create target view 
create view target_view as select * from target where edate < '2007-07-01' with check option;


--source table
create table source_tbl(
        name char(20),
        id varchar(10), 
        edate date,
        email varchar
);

--same with target
insert into source_tbl values('aaa', 'db110', '2000-12-25', 'aaa@db.com');
insert into source_tbl values('fff', 'db211', '2002-03-25', 'fff@db.com');
--updated, email unchanged
insert into source_tbl values('eeee', 'db148', '2002-04-12', 'eee@db.com');
insert into source_tbl values('hhhh', 'db212', '2002-04-25', 'hhh@db.com');
--inserted, new email
insert into source_tbl values('abc', 'db300', '2006-12-12', 'abc@db.com');
insert into source_tbl values('bcd', 'db301', '2008-12-12', 'bcd@db.com');
insert into source_tbl values('cde', 'db333', '2009-01-01', 'cde@db.com');
--others, id starting with 'dev'
insert into source_tbl values('ccc', 'dev101', null, null);
insert into source_tbl values('iii', 'dev102', null, null);
insert into source_tbl values('ccd', 'dev103', null, null);
insert into source_tbl values('cce', 'dev104', null, null);


--create source view
create view source_view as select * from source_tbl where id like 'db%' or id like 'dev%' with check option;


commit;


--TEST: error, only with delete clause 
merge into target_view t
using source_view
on (t.email = source_vuiew.email)
when matched then
delete where name > 'aaa';
rollback;


--TEST: error, check option error, update + delete
merge into target_view t
using source_view s
on (left(t.email, 3) = left(s.email, 3))
when matched then
update
set t.name = s.name, t.edate = add_months(t.edate, 60), t.id = s.id
delete where t.id < 'db301';
--TEST: check merge result
select if(count(*)=0, 'ok', 'nok') from target_view where name in ('hhhh', 'eeee');
select if(count(*)=0, 'ok', 'nok') from target where edate >= '2007-07-01';
rollback;



--TEST: update clause with where conditions + delete, 2 rows merged, no rows deleted
merge into target_view t
using source_view s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id, t.edate = add_months(s.edate, 24)
where t.id != s.id
delete where year(t.edate)=2003;
--TEST: check merge result
select if(count(*)=2, 'ok', 'nok') from target_view where name in ('hhhh', 'eeee');
select if(count(*)=10, 'ok', 'nok') from target;
rollback;


--TEST: update + delete + insert with where conditions, 3 rows merged, 4 rows deleted.
merge into target_view t
using source_view s
on (t.email = s.email)
when matched then
update
set t.edate = s.edate
where t.id = s.id and t.name = s.name
delete where s.id like 'db%'
when not matched then
insert 
values(s.name, s.id, s.edate, s.email)
where year(s.edate) < 2007;
--TEST: check merge result
select if(count(*)=9, 'ok', 'nok') from target_view order by email;
select * from target order by email;
rollback;


--TEST: with delete clause, with check violation in insert clause.
merge into target_view t
using source_view s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id
where year(s.edate) < 2007 
delete where t.edate = s.edate
when not matched then
insert
values(s.name, s.id, add_months(s.edate, 70), s.email);
--TEST: check merge result
select if(count(*)=0, 'ok', 'nok') from target_view where name in ('hhhh', 'eeee');
select if(count(*)=0, 'ok', 'nok') from target where edate >= '2007-07-01';
rollback;


drop view target_view, source_view;
drop table target, source_tbl;
commit;


autocommit on;
                       



set system parameters 'create_table_reuseoid=yes';
