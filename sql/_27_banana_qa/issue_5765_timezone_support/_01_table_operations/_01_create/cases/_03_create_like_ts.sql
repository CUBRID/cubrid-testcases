--create table with TIMESTAMP(L)TZ columns, using create … like syntax


drop table if exists tztest;

create table tztest(
	c1 timestamp with time zone default current_timestamp,
	c2 timestamp with time zone not null,
	c3 timestamp with local time zone unique,
	c4 timestamp with local time zone default now() not null,
	c5 timestamp unique not null	
);

desc tztest;

--test: create table with create ... like statement
create table tzlike like tztest;

show full columns in tzlike;

drop table tztest;
drop table tzlike;


