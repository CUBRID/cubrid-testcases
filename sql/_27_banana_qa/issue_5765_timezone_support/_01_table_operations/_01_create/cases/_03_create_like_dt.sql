--create table with DATETIME(L)TZ columns, using create … like syntax


drop table if exists tztest;

create table tztest(
	c1 datetime with time zone default current_datetime,
	c2 datetime with time zone not null,
	c3 datetime with local time zone unique,
	c4 datetime with local time zone default now() not null,
	c5 datetime unique not null	
);

desc tztest;

--test: create table with create ... like statement
create table tzlike like tztest;

show full columns in tzlike;

drop table tztest;
drop table tzlike;


