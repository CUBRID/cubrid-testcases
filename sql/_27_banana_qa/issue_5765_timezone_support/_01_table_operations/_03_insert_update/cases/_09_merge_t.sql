--test TIME(L)TZ columns, with merge statement

set timezone '+9:00';

drop table if exists target, source;

create table target(id int, col datetime with local time zone, str char(10));
create table source(id int, col datetime with time zone, str char(10));

insert into target values(1, datetimeltz'2015-9-17 14:00:00', 'a');
insert into target values(2, datetimeltz'2015-9-17 14:00:00 +8:00', 'b');
insert into target values(3, datetimeltz'2015-9-17 14:00:00 +2:00', 'c');

insert into source values(11, datetimetz'2015-9-17 14:00:00 Asia/Seoul', 'aa');
insert into source values(33, datetimetz'2015-9-17 14:00:00 +2:00', 'cc');
insert into source values(44, datetimetz'2015-9-17 14:00:00 +10:00', 'inserted');
insert into source values(55, datetimetz'2015-9-17 14:00:00 +14:00', 'inserted');

--test: merge statement
merge into target t using source s on t.col=s.col
when matched then update set t.id=s.id, t.str=s.str
delete where t.col=datetimetz'2015-9-17 5:00:00 GMT'
when not matched then insert values(id, col, str);

select * from target order by id;



drop table target, source;

set timezone 'Asia/Seoul';
