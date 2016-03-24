--change TIMESTAMPTZ from without DEFAULT/constraints to with DEFAULT/constraints, strict yes

set system parameters 'alter_table_change_type_strict=yes';


drop table if exists tz;

create table tz(
	c_tstz1 timestamp with time zone,
	c_tstz2 timestamp with time zone,
	c_tstz3 timestamp with time zone,
	c_tstz4 timestamp with time zone,
	c_tstz5 timestamp with time zone,
	c_tstz6 timestamp with time zone
);

insert into tz values('2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00','2014-07-01 18:00:00 -6:00', null, null);
insert into tz values(null, '2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00','2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -6:00', null);
insert into tz values('2014-07-01 18:00:00 -6:00', null, '2014-07-01 18:00:00 -6:00','2014-07-01 19:00:00 -4:00', '2014-07-01 18:00:00 -6:00', null);
insert into tz values('2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00', '2014-07-01 20:00:00 -6:00', null, '2014-07-01 18:00:00 -6:00', null);


--test: not null
alter table tz change c_tstz1 c_tstz11 timestamp with time zone not null;
desc tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: default
alter table tz change c_tstz2 c_tstz22 timestamp with time zone default now();
desc tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: unique
alter table tz change c_tstz3 c_tstz33 timestamp with time zone unique;
show columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: pk
alter table tz change c_tstz4 c_tstz44 timestamp with time zone primary key;
show columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: not null + defualt
alter table tz change c_tstz5 c_tstz55 timestamp with time zone not null default '2000-10-10 10:10:10 +00:00';
show full columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: unique + not null + default
alter table tz change c_tstz6 c_tstz66 timestamp with time zone default '2000-10-10 10:10:10 +00:00' unique not null;
show full columns in tz;
select * from tz order by 1, 2, 3, 4, 5;


drop table tz;


set system parameters 'alter_table_change_type_strict=no';
