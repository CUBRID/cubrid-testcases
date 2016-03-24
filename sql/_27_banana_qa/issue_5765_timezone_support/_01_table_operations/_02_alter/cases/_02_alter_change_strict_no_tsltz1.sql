--change TIMESTAMPLTZ from without DEFAULT/constraints to with DEFAULT/constraints, strict no

set system parameters 'alter_table_change_type_strict=no';


drop table if exists tz;

create table tz(
	id int,
	c_tsltz1 timestamp with local time zone,
	c_tsltz2 timestamp with local time zone,
	c_tsltz3 timestamp with local time zone,
	c_tsltz4 timestamp with local time zone,
	c_tsltz5 timestamp with local time zone,
	c_tsltz6 timestamp with local time zone
);

insert into tz values(1, '2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00','2014-07-01 18:00:00 -6:00', null, null);
insert into tz values(2, null, '2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -5:00','2014-07-01 18:00:00 -5:00', '2014-07-01 18:00:00 -6:00', null);
insert into tz values(3, '2014-07-01 18:00:00 -6:00', null, '2014-07-01 18:00:00 -4:00','2014-07-01 19:00:00 -4:00', '2014-07-01 18:00:00 -6:00', null);
insert into tz values(4, '2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -6:00', '2014-07-01 18:00:00 -3:00', null, '2014-07-01 18:00:00 -6:00', null);


--test: not null
alter table tz change c_tsltz1 c_tsltz11 timestamp with local time zone not null;
desc tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: default
alter table tz change c_tsltz2 c_tsltz22 timestamp with local time zone default now();
desc tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: unique
alter table tz change c_tsltz3 c_tsltz33 timestamp with local time zone unique;
show columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: pk
alter table tz change c_tsltz4 c_tsltz44 timestamp with local time zone primary key;
show columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: not null + defualt
alter table tz change c_tsltz5 c_tsltz55 timestamp with local time zone not null default '2000-10-10 10:10:10 +00:00';
show full columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: [er] unique + not null + default
alter table tz change c_tsltz6 c_tsltz66 timestamp with local time zone default '2000-10-10 10:10:10 +00:00' unique not null;
--test: not null + defualt
alter table tz change c_tsltz6 c_tsltz66 timestamp with local time zone default '2000-10-10 10:10:10 +00:00' not null;
show full columns in tz;
select * from tz order by 1, 2, 3, 4, 5;


drop table tz;


