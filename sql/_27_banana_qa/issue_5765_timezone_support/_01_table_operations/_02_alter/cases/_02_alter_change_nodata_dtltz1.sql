--change DATETIMELTZ from without DEFAULT/constraints to with DEFAULT/constraints, no data


drop table if exists tz;

create table tz(
	c_dtltz1 datetime with local time zone,
	c_dtltz2 datetime with local time zone,
	c_dtltz3 datetime with local time zone,
	c_dtltz4 datetime with local time zone,
	c_dtltz5 datetime with local time zone
);


--test: not null
alter table tz change c_dtltz1 c_dtltz11 datetime with local time zone not null;
desc tz;

--test: default
alter table tz change c_dtltz2 c_dtltz22 datetime with local time zone default now();
desc tz;

--test: [er] auto_increment
alter table tz change c_dtltz3 c_dtltz33 datetime with local time zone auto_increment;

--test: pk
alter table tz change c_dtltz4 c_dtltz44 datetime with local time zone primary key;
show columns in tz;

--test: unique
alter table tz change c_dtltz5 c_dtltz55 datetime with local time zone unique;
show full columns in tz;


drop table tz;


