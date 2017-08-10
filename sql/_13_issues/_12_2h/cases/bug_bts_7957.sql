--TEST: [Merge Statement] Various core files dumped when executing merge statement.

drop table if exists target;
drop table if exists source;

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


create table source(
        name char(20),
        id char(10),
        edate date,
        email varchar
);

insert into source values('aaa', 'db110', '2000-12-25', 'aaa@db.com');
insert into source values('fff', 'db211', '2002-03-25', 'fff@db.com');
insert into source values('eeee', 'db148', '2002-04-12', 'eee@db.com');
insert into source values('cde', 'db333', '2009-01-01', 'cde@db.com');

merge into target t
using source s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id
where year(s.id) < 2007
delete where(t.edate = s.edate)
when not matched then
insert
values(s.name, s.id, add_months(s.edate, 70), s.email);

merge into target t
using source s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id
where year(s.id) < 2007
delete where(t.edate = s.edate)
when not matched then
insert
values(s.name, s.id, add_months(s.edate, 70), s.email);

merge into target t
using source s
on (t.email = s.email)
when matched then
update
set t.name = s.name, t.id = s.id
where year(s.id) < 2007
delete where(t.edate = s.edate)
when not matched then
insert
values(s.name, s.id, add_months(s.edate, 70), s.email);


drop table target, source;
