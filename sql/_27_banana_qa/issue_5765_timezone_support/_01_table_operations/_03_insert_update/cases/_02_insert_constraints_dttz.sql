--insert into DATETIMETZ columns with constraints


drop table if exists tz_test;

create table tz_test(
	id int auto_increment,
	c0 datetime with time zone primary key,
	c1 datetime with time zone not null,
	c2 datetime with time zone default datetimetz'2001-12-12 3:15:34.111 +2:00',
	c3 datetime with time zone not null default datetimetz'1999-10-11 12:23:34.567 -10:00',
	c4 datetime with time zone shared '1997-07-01 12:00:00 +11:00'
);


insert into tz_test(c0, c1, c2, c3) values (datetimetz'2003-03-30 02:30:00.999 +6:00', datetimetz'2003-03-30 02:30:00.999 +6:00', datetimetz'2003-03-30 02:30:0', datetimetz'2003-03-30 02:30:00.999 +6:00');
select * from tz_test order by 1;

--test: [er] primary key, null
insert into tz_test(c1, c2, c3) values(datetimetz'2003-03-30 02:30:00.999 +6:00', datetimetz'2003-03-30 02:30:00.999 +6:00', datetimetz'2003-03-30 02:30:0');
--test: [er] primary key, unique violation
insert into tz_test(c0, c1) select c0, c1 from tz_test;

--test: [er] not null violation
insert into tz_test set c0=datetimetz'2004-01-02 23:10:34.2 Asia/Seoul', c1=null;
insert into tz_test(c0, c3) values(datetimetz'2004-01-02 23:10:34.2 Asia/Seoul', datetimetz'2004-01-02 23:10:34.2 Asia/Seoul');

--test: default 
insert into tz_test(c0, c1, c3, c4) values(datetimetz'2005-03-30 02:30:00.999 -7:30', datetimetz'2005-03-30 02:30:00.999 -7:30', datetimetz'2005-03-30 02:30:00.999 -7:30', datetimetz'2005-03-30 02:30:00.999 -7:30');
select * from tz_test order by 1;
insert into tz_test(c0, c1, c2) select c1+1, c2+1, default(c2)+1 from tz_test where id=last_insert_id();
select * from tz_test order by 1;
insert into tz_test values(default, datetimetz'2006-03-30 02:30:00.999 Asia/Harbin', datetimetz'2006-03-30 02:30:00.999 Asia/Harbin', default, default, default);
select * from tz_test order by 1;

--test: foreign key
create table fk(id int, c datetime with time zone primary key, constraint fk_id foreign key(c) references tz_test(c0) on delete cascade on update restrict);
insert into fk values(1, datetimetz'2003-03-30 02:30:00.999 +6:00'), (2, datetimetz'2005-03-30 02:30:00.999 -7:30');
select * from fk order by 1;
--test: [er] foreign key violation
insert into fk values(3, datetimetz'2005-03-30 04:30:00.012 Asia/Baghdad');
--test: fk constraints, delete
delete from tz_test where id=3;
select * from fk order by 1;
--test: [er] fk constraints, update
update tz_test set c0=datetimetz'2009-03-30 04:30:00.012 -1:00' where id=1;


--test: truncate statement
truncate table tz_test;
select if(count(*)=0, 'ok', 'nok') from tz_test;
select if(count(*)=0, 'ok', 'nok') from fk;


drop table tz_test, fk cascade constraints;


