--test DATETIME(L)Tzcolumns, with merge statement

set timezone 'Asia/Seoul';

drop table if exists target, source;

create table target(id int, col datetime with local time zone, str char(10));
create table source(id int, col datetime with time zone, str char(10));

insert into target values(1, datetimeltz'2014-7-1 14:00:00.999', 'a');
insert into target values(2, datetimeltz'2014-7-1 14:00:00.999 Asia/Shanghai', 'b');
insert into target values(3, datetimeltz'2014-7-1 14:00:00.999 Europe/Andorra', 'c');

insert into source values(11, datetimetz'2014-7-1 14:00:00.999 Asia/Seoul', 'aa');
insert into source values(33, datetimetz'2014-7-1 14:00:00.999 Europe/Vienna', 'cc');
insert into source values(44, datetimetz'2014-7-1 14:00:00.999 America/Thule', 'inserted');
insert into source values(55, datetimetz'2014-7-1 14:00:00.999 +14:00', 'inserted');

--test: merge statement
merge into target t using source s on t.col=s.col
when matched then update set t.id=s.id, t.str=s.str
delete where t.col=datetimetz'2014-7-1 5:00:00.999 GMT'
when not matched then insert values(id, col, str);

select * from target order by id;



drop table target, source;

set timezone 'Asia/Seoul';
