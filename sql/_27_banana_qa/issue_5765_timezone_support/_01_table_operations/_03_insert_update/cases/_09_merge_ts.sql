--test TIMESTAMP(L)Tzcolumns, with merge statement

set timezone 'Asia/Seoul';

drop table if exists target, source;

create table target(id int, col timestamp with local time zone, str char(10));
create table source(id int, col timestamp with time zone, str char(10));

insert into target values(1, timestampltz'2014-7-1 14:00:00', 'a');
insert into target values(2, timestampltz'2014-7-1 14:00:00 Asia/Shanghai', 'b');
insert into target values(3, timestampltz'2014-7-1 14:00:00 Europe/Andorra', 'c');

insert into source values(11, timestamptz'2014-7-1 14:00:00 Asia/Seoul', 'aa');
insert into source values(33, timestamptz'2014-7-1 14:00:00 Europe/Vienna', 'cc');
insert into source values(44, timestamptz'2014-7-1 14:00:00 America/Thule', 'inserted');
insert into source values(55, timestamptz'2014-7-1 14:00:00 +14:00', 'inserted');

--test: merge statement
merge into target t using source s on t.col=s.col
when matched then update set t.id=s.id, t.str=s.str
delete where t.col=timestamptz'2014-7-1 5:00:00 GMT'
when not matched then insert values(id, col, str);

select * from target order by id;



drop table target, source;

set timezone 'Asia/Seoul';
