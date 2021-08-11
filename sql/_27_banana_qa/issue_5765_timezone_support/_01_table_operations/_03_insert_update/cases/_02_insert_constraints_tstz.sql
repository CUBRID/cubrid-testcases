--insert into TIMESTAMPTZ columns with constraints


drop table if exists tz_test;

create table tz_test(
	id int auto_increment,
	c0 timestamp with time zone primary key,
	c1 timestamp with time zone not null,
	c2 timestamp with time zone default timestamptz'2001-12-12 3:15:34 +2:00',
	c3 timestamp with time zone not null default timestamptz'1999-10-11 12:23:34 -10:00',
	c4 timestamp with time zone shared '1997-07-01 12:00:00 +11:00'
);


insert into tz_test(c0, c1, c2, c3) values (timestamptz'2003-03-30 02:30:00 +6:00', timestamptz'2003-03-30 02:30:00 +6:00', timestamptz'2003-03-30 02:30:0', timestamptz'2003-03-30 02:30:00 +6:00');
select * from tz_test order by 1;

--test: [er] primary key, null
insert into tz_test(c1, c2, c3) values(timestamptz'2003-03-30 02:30:00 +6:00', timestamptz'2003-03-30 02:30:00 +6:00', timestamptz'2003-03-30 02:30:0');
--test: [er] primary key, unique violation
insert into tz_test(c0, c1) select c0, c1 from tz_test;

--test: [er] not null violation
insert into tz_test set c0=timestamptz'2004-01-02 23:10:34 Asia/Seoul', c1=null;
insert into tz_test(c0, c3) values(timestamptz'2004-01-02 23:10:34 Asia/Seoul', timestamptz'2004-01-02 23:10:34 Asia/Seoul');

--test: default 
insert into tz_test(c0, c1, c3, c4) values(timestamptz'2005-03-30 02:30:00 -7:30', timestamptz'2005-03-30 02:30:00 -7:30', timestamptz'2005-03-30 02:30:00 -7:30', timestamptz'2005-03-30 02:30:00 -7:30');
select * from tz_test order by 1;
insert into tz_test(c0, c1, c2) select c1+1, c2+1, default(c2)+1 from tz_test where id=last_insert_id();
select * from tz_test order by 1;
insert into tz_test values(default, timestamptz'2006-03-30 02:30:00 Asia/Harbin', timestamptz'2006-03-30 02:30:00 Asia/Harbin', default, default, default);
select * from tz_test order by 1;

--test: foreign key
create table fk(id int, c timestamp with time zone primary key, constraint fk_id foreign key(c) references tz_test(c0) on delete cascade on update restrict);
insert into fk values(1, timestamptz'2003-03-30 02:30:00 +6:00'), (2, timestamptz'2005-03-30 02:30:00 -7:30');
select * from fk order by 1;
--test: [er] foreign key violation
insert into fk values(3, timestamptz'2005-03-30 04:30:00 Asia/Baghdad');
--test: fk constraints, delete
delete from tz_test where id=3;
select * from fk order by 1;
--test: [er] fk constraints, update
update tz_test set c0=timestamptz'2009-03-30 04:30:00 -1:00' where id=1;


--test: truncate statement
truncate table tz_test cascade;
select if(count(*)=0, 'ok', 'nok') from tz_test;
select if(count(*)=0, 'ok', 'nok') from fk;


drop table tz_test, fk cascade constraints;


