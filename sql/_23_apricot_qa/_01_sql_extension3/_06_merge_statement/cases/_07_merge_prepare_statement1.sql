--test with prepare statement



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


--source table
create table source_tbl(
	noneed1 datetime default SYS_DATETIME,
        name char(20),
        id varchar(20), 
	noneed2 bigint not null,
        edate date,
        email varchar,
	noneed3 sequence(char(10))
);

--same with target
insert into source_tbl values(default, 'aaa', 'db110', 100000, '2000-12-25', 'aaa@db.com', {'a', 'b', 'c'});
insert into source_tbl values(default, 'fff', 'db211', 200000, '2002-03-25', 'fff@db.com', {'a', 'b', 'c'});
--updated, email unchanged
insert into source_tbl values(default, 'eeee', 'db148', 300000, '2002-04-12', 'eee@db.com', {'a', 'b', 'c'});
insert into source_tbl values(default, 'hhhh', 'db212', 400000, '2002-04-25', 'hhh@db.com', {'a', 'b', 'c'});
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
prepare st from 'merge into target t
using (select name, id, edate, email from source_tbl where id like ?) s
on (t.email = s.email)';
execute st using 'db%';


--TEST: error, with insert clause, without update clause, insert part of the values
prepare st from 'merge into target t
using (select name, id, edate, email from source_tbl where id like ?) s
on t.email = s.email
when not matched then
insert
values(s.id, s.edate)';
execute st using 'db%';
--TEST: check merge result
select * from target order by email;

--TEST: with update clause, without insert clause, 4 rows merged
prepare st from 'merge into target t
using (select name, id, edate, email from source_tbl where id like ?) s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.edate = s.edate, t.id = s.id';
execute st using 'db%';
--TEST: check merge result
select if(count(*)=2, 'ok', 'nok') from target where name in ('hhhh', 'eeee');
rollback;


--TEST: with insert clause, without update clause, 3 row merged
prepare st from 'merge into target t
using (select name, id, edate, email from source_tbl where id like ?) s
on (t.email = s.email)
when not matched then
insert
values(s.name, s.id, s.edate, s.email)';
execute st using 'db%';
--TEST: check merge result
select if(count(*)=13, 'ok', 'nok') from target;
rollback;


--TEST: with update clause with where conditions, 2 rows merged
prepare st from 'merge into target t
using (select name, id, edate, email from source_tbl where id like ?) s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id, t.edate = s.edate
where t.id != s.id'; 
execute st using 'db%';
--TEST: check merge result
select if(count(*)=2, 'ok', 'nok') from target where name in ('hhhh', 'eeee');
rollback;


--TEST: with both update and insert clause with where conditions, 3 rows merged
prepare st from 'merge into target t
using (select name, id, edate, email from source_tbl where id like ?) s
on (t.email = s.email)
when matched then
update
set t.edate = s.edate
where t.id = s.id and t.name = s.name
when not matched then
insert 
values(s.name, s.id, s.edate, s.email)
where year(s.edate) = ?';
execute st using 'db%', 2008;
--TEST: check merge result
select if(count(*)=12, 'ok', 'nok') from target;
rollback;


--TEST: with delete clause, 4 rows merged
prepare st from 'merge into target t
using (select name, id, edate, email from source_tbl where id like ?) s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id
delete where(t.edate = s.edate)
when not matched then
insert
values(s.name, s.id, s.edate, s.email)';
execute st using 'db%';
--TEST: check merge result
select if(count(*)=2, 'ok', 'nok') from target where name in ('hhhh', 'eeee');
select if(count(*)=11, 'ok', 'nok') from target order by email;
rollback;

deallocate prepare st;


drop table target, source_tbl;
commit;


autocommit on;
                       



