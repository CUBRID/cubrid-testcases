--change DATETIMETZ from without DEFAULT/constraints to with DEFAULT/constraints, strict yes

set system parameters 'alter_table_change_type_strict=yes';


drop table if exists tz;

create table tz(
	c_dttz1 datetime with time zone,
	c_dttz2 datetime with time zone,
	c_dttz3 datetime with time zone,
	c_dttz4 datetime with time zone,
	c_dttz5 datetime with time zone,
	c_dttz6 datetime with time zone
);

insert into tz values('2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00','2014-07-01 18:00:00.789 -6:00', null, null);
insert into tz values(null, '2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00','2014-07-01 18:00:00.789 -5:00', '2014-07-01 18:00:00.789 -6:00', null);
insert into tz values('2014-07-01 18:00:00.789 -6:00', null, '2014-07-01 18:00:00.789 -6:00','2014-07-01 19:00:00.789 -4:00', '2014-07-01 18:00:00.789 -6:00', null);
insert into tz values('2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00', '2014-07-01 20:00:00.789 -6:00', null, '2014-07-01 18:00:00.789 -6:00', null);


--test: not null
alter table tz change c_dttz1 c_dttz11 datetime with time zone not null;
desc tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: default
alter table tz change c_dttz2 c_dttz22 datetime with time zone default now();
desc tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: unique
alter table tz change c_dttz3 c_dttz33 datetime with time zone unique;
show columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: pk
alter table tz change c_dttz4 c_dttz44 datetime with time zone primary key;
show columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: not null + defualt
alter table tz change c_dttz5 c_dttz55 datetime with time zone not null default '2000-10-10 10:10:10.123 +00:00';
show full columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: unique + not null + default
alter table tz change c_dttz6 c_dttz66 datetime with time zone default '2000-10-10 10:10:10.123 +00:00' unique not null;
show full columns in tz;
select * from tz order by 1, 2, 3, 4, 5;


drop table tz;


set system parameters 'alter_table_change_type_strict=no';
