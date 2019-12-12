--create table with DATETIME(L)TZ columns, using create … as select syntax


drop table if exists tztest;

create table tztest(
	c1 datetime with time zone default current_datetime,
	c2 datetime with time zone not null,
	c3 datetime with local time zone unique,
	c4 datetime with local time zone default now() not null,
	c5 datetime unique not null	
);

desc tztest;

insert into tztest values(
	datetimetz'2003-01-01 2:00:00.999 -08:00', 
	datetimetz'2003-01-01 2:00:00.999 -08:00',
	datetimeltz'2003-01-01 2:00:00.999 -08:00',
	datetimeltz'2003-01-01 2:00:00.999 -08:00',
	datetime'2003-01-01 2:00:00.999'
);

--test: create table with create ... as select statement
create table tzlike as select * from tztest;

show full columns in tzlike;
select * from tzlike order by 1;

drop table tztest;
drop table tzlike;


