--change TIMESTAMPLTZ from with DEFAULT/constraints to without DEFAULT/constraints, strict yes

set system parameters 'alter_table_change_type_strict=yes';

drop table if exists tz;

create table tz(
	c_tsltz1 timestamp with local time zone not null,
	c_tsltz2 timestamp with local time zone default current_timestamp,
	c_tsltz3 timestamp with local time zone primary key,
	c_tsltz4 timestamp with local time zone unique not null,
	c_tsltz5 timestamp with local time zone not null default current_timestamp
);

insert into tz values('2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00','2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00');
insert into tz values('2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -5:00');
insert into tz values('2014-07-01 18:00:00 -4:00', '2014-07-01 18:00:00 -4:00', '2014-07-01 18:00:00 -4:00', '2014-07-01 18:00:00 -4:00', '2014-07-01 18:00:00 -4:00');


--test: not null
alter table tz change c_tsltz1 c_tsltz11 timestamp with local time zone;
desc tz;

--test: default
alter table tz change c_tsltz2 c_tsltz22 timestamp with local time zone;
desc tz;

--test: pk
alter table tz change c_tsltz3 c_tsltz33 timestamp with local time zone;
show columns in tz;

--test: unique + not null
alter table tz change c_tsltz4 c_tsltz44 timestamp with local time zone;
desc tz;

--test: not null + default
alter table tz change c_tsltz5 c_tsltz55 timestamp with local time zone;
show full columns in tz;


drop table tz;


set system parameters 'alter_table_change_type_strict=no';
