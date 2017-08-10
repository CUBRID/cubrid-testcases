--create table with TIMESTAMP(L)TZ columns, using create … like syntax


drop table if exists tz_super1;
drop table if exists tz_super2;

create table tz_super1(
	c1 timestamp with time zone default current_timestamp,
	c2 timestamp with time zone not null
);

create table tz_super2(
	c3 timestamp with local time zone unique,
	c4 timestamp with local time zone default now() not null,
	c5 timestamp unique not null	
);

desc tz_super1;
desc tz_super2;


--test: create sub-table
create table tz_sub1 under tz_super1, tz_super2 inherit c1 of tz_super1, c3 of tz_super2, c5 of tz_super2;
show full columns in tz_sub1;

--testL create sub table of a sub table
create table tz_sub2 under tz_sub1;
desc tz_sub2;


drop table tz_super1, tz_super2;
drop table tz_sub1, tz_sub2;


