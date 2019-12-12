--create table with TIMESTAMP(L)TZ columns, using create … as select syntax


drop table if exists tztest;

create table tztest(
	c1 timestamp with time zone default current_timestamp,
	c2 timestamp with time zone not null,
	c3 timestamp with local time zone unique,
	c4 timestamp with local time zone default now() not null,
	c5 timestamp unique not null	
);

desc tztest;

insert into tztest values(
	timestamptz'2003-01-01 2:00:00 -08:00', 
	timestamptz'2003-01-01 2:00:00 -08:00',
	timestampltz'2003-01-01 2:00:00 -08:00',
	timestampltz'2003-01-01 2:00:00 -08:00',
	timestamp'2003-01-01 2:00:00'
);

--test: create table with create ... as select statement
create table tzlike as select * from tztest;

show full columns in tzlike;
select * from tzlike order by 1;

drop table tztest;
drop table tzlike;


