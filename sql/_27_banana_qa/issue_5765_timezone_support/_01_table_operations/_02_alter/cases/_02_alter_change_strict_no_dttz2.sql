--change DATETIMETZ from with DEFAULT/constraints to without DEFAULT/constraints, strict no

set system parameters 'alter_table_change_type_strict=no';

drop table if exists tz;

create table tz(
	c_dttz1 datetime with time zone not null,
	c_dttz2 datetime with time zone default current_datetime,
	c_dttz3 datetime with time zone primary key,
	c_dttz4 datetime with time zone unique not null,
	c_dttz5 datetime with time zone not null default current_datetime
);

insert into tz values('2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00','2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00');
insert into tz values('2014-07-01 18:00:00.789 -5:00', '2014-07-01 18:00:00.789 -5:00', '2014-07-01 18:00:00.789 -5:00', '2014-07-01 18:00:00.789 -5:00', '2014-07-01 18:00:00.789 -5:00');
insert into tz values('2014-07-01 18:00:00.789 -4:00', '2014-07-01 18:00:00.789 -4:00', '2014-07-01 18:00:00.789 -4:00', '2014-07-01 18:00:00.789 -4:00', '2014-07-01 18:00:00.789 -4:00');


--test: not null
alter table tz change c_dttz1 c_dttz11 datetime with time zone;
desc tz;

--test: default
alter table tz change c_dttz2 c_dttz22 datetime with time zone;
desc tz;

--test: pk
alter table tz change c_dttz3 c_dttz33 datetime with time zone;
show columns in tz;

--test: unique + not null
alter table tz change c_dttz4 c_dttz44 datetime with time zone;
desc tz;

--test: not null + default
alter table tz change c_dttz5 c_dttz55 datetime with time zone;
show full columns in tz;


drop table tz;


