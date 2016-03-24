--change DATETIMELTZ from without DEFAULT/constraints to with DEFAULT/constraints, strict no

set system parameters 'alter_table_change_type_strict=no';


drop table if exists tz;

create table tz(
	id int,
	c_dtltz1 datetime with local time zone,
	c_dtltz2 datetime with local time zone,
	c_dtltz3 datetime with local time zone,
	c_dtltz4 datetime with local time zone,
	c_dtltz5 datetime with local time zone,
	c_dtltz6 datetime with local time zone
);

insert into tz values(1, '2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00','2014-07-01 18:00:00.789 -6:00', null, null);
insert into tz values(2, null, '2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -5:00','2014-07-01 18:00:00.789 -5:00', '2014-07-01 18:00:00.789 -6:00', null);
insert into tz values(3, '2014-07-01 18:00:00.789 -6:00', null, '2014-07-01 18:00:00.789 -4:00','2014-07-01 19:00:00.789 -4:00', '2014-07-01 18:00:00.789 -6:00', null);
insert into tz values(4, '2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -6:00', '2014-07-01 18:00:00.789 -3:00', null, '2014-07-01 18:00:00.789 -6:00', null);


--test: not null
alter table tz change c_dtltz1 c_dtltz11 datetime with local time zone not null;
desc tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: default
alter table tz change c_dtltz2 c_dtltz22 datetime with local time zone default now();
desc tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: unique
alter table tz change c_dtltz3 c_dtltz33 datetime with local time zone unique;
show columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: pk
alter table tz change c_dtltz4 c_dtltz44 datetime with local time zone primary key;
show columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: not null + defualt
alter table tz change c_dtltz5 c_dtltz55 datetime with local time zone not null default '2000-10-10 10:10:10.123 +00:00';
show full columns in tz;
select * from tz order by 1, 2, 3, 4, 5;

--test: [er] unique + not null + default
alter table tz change c_dtltz6 c_dtltz66 datetime with local time zone default '2000-10-10 10:10:10.123 +00:00' unique not null;
--test: not null + defualt
alter table tz change c_dtltz6 c_dtltz66 datetime with local time zone default '2000-10-10 10:10:10.123 +00:00' not null;
show full columns in tz;
select * from tz order by 1, 2, 3, 4, 5;


drop table tz;


