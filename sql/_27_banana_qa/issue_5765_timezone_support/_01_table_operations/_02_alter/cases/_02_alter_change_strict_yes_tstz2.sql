--change TIMESTAMPTZ from with DEFAULT/constraints to without DEFAULT/constraints, strict yes

set system parameters 'alter_table_change_type_strict=yes';

drop table if exists tz;

create table tz(
	c_tstz1 timestamp with time zone not null,
	c_tstz2 timestamp with time zone default current_timestamp,
	c_tstz3 timestamp with time zone primary key,
	c_tstz4 timestamp with time zone unique not null,
	c_tstz5 timestamp with time zone not null default current_timestamp
);

insert into tz values('2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00','2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00');
insert into tz values('2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -5:00');
insert into tz values('2014-07-01 18:00:00 -4:00', '2014-07-01 18:00:00 -4:00', '2014-07-01 18:00:00 -4:00', '2014-07-01 18:00:00 -4:00', '2014-07-01 18:00:00 -4:00');


--test: not null
alter table tz change c_tstz1 c_tstz11 timestamp with time zone;
desc tz;

--test: default
alter table tz change c_tstz2 c_tstz22 timestamp with time zone;
desc tz;

--test: pk
alter table tz change c_tstz3 c_tstz33 timestamp with time zone;
show columns in tz;

--test: unique + not null
alter table tz change c_tstz4 c_tstz44 timestamp with time zone;
desc tz;

--test: not null + default
alter table tz change c_tstz5 c_tstz55 timestamp with time zone;
show full columns in tz;


drop table tz;


set system parameters 'alter_table_change_type_strict=no';
