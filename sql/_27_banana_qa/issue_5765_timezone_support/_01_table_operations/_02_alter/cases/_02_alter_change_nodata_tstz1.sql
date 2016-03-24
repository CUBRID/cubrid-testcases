--change TIMESTAMPTZ from without DEFAULT/constraints to with DEFAULT/constraints, no data


drop table if exists tz;

create table tz(
	c_tstz1 timestamp with time zone,
	c_tstz2 timestamp with time zone,
	c_tstz3 timestamp with time zone,
	c_tstz4 timestamp with time zone,
	c_tstz5 timestamp with time zone
);


--test: not null
alter table tz change c_tstz1 c_tstz11 timestamp with time zone not null;
desc tz;

--test: default
alter table tz change c_tstz2 c_tstz22 timestamp with time zone default now();
desc tz;

--test: [er] auto_increment
alter table tz change c_tstz3 c_tstz33 timestamp with time zone auto_increment;

--test: pk
alter table tz change c_tstz4 c_tstz44 timestamp with time zone primary key;
show columns in tz;

--test: unique
alter table tz change c_tstz5 c_tstz55 timestamp with time zone unique;
show full columns in tz;


drop table tz;


