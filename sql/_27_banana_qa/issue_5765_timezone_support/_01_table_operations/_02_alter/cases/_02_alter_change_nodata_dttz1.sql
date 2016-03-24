--change DATETIMETZ from without DEFAULT/constraints to with DEFAULT/constraints, no data


drop table if exists tz;

create table tz(
	c_dttz1 datetime with time zone,
	c_dttz2 datetime with time zone,
	c_dttz3 datetime with time zone,
	c_dttz4 datetime with time zone,
	c_dttz5 datetime with time zone
);


--test: not null
alter table tz change c_dttz1 c_dttz11 datetime with time zone not null;
desc tz;

--test: default
alter table tz change c_dttz2 c_dttz22 datetime with time zone default now();
desc tz;

--test: [er] auto_increment
alter table tz change c_dttz3 c_dttz33 datetime with time zone auto_increment;

--test: pk
alter table tz change c_dttz4 c_dttz44 datetime with time zone primary key;
show columns in tz;

--test: unique
alter table tz change c_dttz5 c_dttz55 datetime with time zone unique;
show full columns in tz;


drop table tz;


