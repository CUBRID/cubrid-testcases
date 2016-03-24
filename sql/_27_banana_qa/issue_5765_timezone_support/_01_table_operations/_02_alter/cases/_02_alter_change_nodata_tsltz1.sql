--change TIMESTAMPLTZ from without DEFAULT/constraints to with DEFAULT/constraints, no data


drop table if exists tz;

create table tz(
	c_tsltz1 timestamp with local time zone,
	c_tsltz2 timestamp with local time zone,
	c_tsltz3 timestamp with local time zone,
	c_tsltz4 timestamp with local time zone,
	c_tsltz5 timestamp with local time zone
);


--test: not null
alter table tz change c_tsltz1 c_tsltz11 timestamp with local time zone not null;
desc tz;

--test: default
alter table tz change c_tsltz2 c_tsltz22 timestamp with local time zone default now();
desc tz;

--test: [er] auto_increment
alter table tz change c_tsltz3 c_tsltz33 timestamp with local time zone auto_increment;

--test: pk
alter table tz change c_tsltz4 c_tsltz44 timestamp with local time zone primary key;
show columns in tz;

--test: unique
alter table tz change c_tsltz5 c_tsltz55 timestamp with local time zone unique;
show full columns in tz;


drop table tz;


