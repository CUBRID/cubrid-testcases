--add DATETIMETZ columns, using alter ... add statement, hard default no

set system parameters 'add_column_update_hard_default=no';

drop table if exists tz;
create table tz(a int);

insert into tz values(1);
insert into tz values(2);
insert into tz values(3);

--test: add column with default
alter table tz add c_dttz1 datetime with time zone default '2003-01-01 2:00:00.789 -8:00';
desc tz;
select * from tz order by a;

--test: [er] add column with not null, without default
alter table tz add c_dttz2 datetime with time zone not null;

--test: add column with unique
alter table tz add c_dttz3 datetime with time zone unique;
show columns in tz;
select * from tz order by a;

--test: [er] add column with unique and not null
alter table tz add c_dttz4 datetime with time zone unique not null;
show columns in tz;
select * from tz order by a;

--test: [er] add column with unique and default
alter table tz add c_dttz5 datetime with time zone default '2003-01-01 2:00:00.789 -8:00' unique;
show columns in tz;
select * from tz order by a;

--test: [er] add column with primary key
alter table tz add c_dttz4 datetime with time zone primary key;
show columns in tz;
select * from tz order by a;

--test: [er] add constraint
alter table tz add constraint pk primary key(c_dttz1);
desc tz;
select * from tz order by a;

--test: alter column set default
alter table tz alter column c_dttz1 set default now();
desc tz;
select * from tz order by a;

--test: add index
alter table tz add index idx(c_dttz1);
update statistics on all classes;
show index in tz;


drop table tz;


