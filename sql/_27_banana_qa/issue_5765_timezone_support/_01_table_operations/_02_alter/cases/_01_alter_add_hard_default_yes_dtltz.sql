--add DATETIMELTZ columns, using alter ... add statement, hard default no

set system parameters 'add_column_update_hard_default=yes';

drop table if exists ltz;
create table ltz(a int);

insert into ltz values(1);
insert into ltz values(2);
insert into ltz values(3);

--test: add column with default
alter table ltz add c_dtltz1 datetime with local time zone default '2003-01-01 2:00:00.789 Europe/London';
desc ltz;
select * from ltz order by a;

--test: add column with not null, without default
alter table ltz add c_dtltz2 datetime with local time zone not null;
desc ltz;
select * from ltz order by a;

--test: add column with unique
alter table ltz add c_dtltz3 datetime with local time zone unique;
show columns in ltz;
select * from ltz order by a;

--test: [er] add column with unique and not null
alter table ltz add c_dtltz4 datetime with local time zone unique not null;
show columns in ltz;
select * from ltz order by a;

--test: [er] add column with unique and default
alter table ltz add c_dtltz5 datetime with local time zone default '2003-01-01 2:00:00.789 -8:00' unique;
show columns in ltz;
select * from ltz order by a;

--test: [er] add column with primary key
alter table ltz add c_dtltz4 datetime with local time zone primary key;
show columns in ltz;
select * from ltz order by a;

--test: [er] add constraint
alter table ltz add constraint pk primary key(c_dtltz1);
desc ltz;
select * from ltz order by a;

--test: alter column set default
alter table ltz alter column c_dtltz1 set default now();
desc ltz;
select * from ltz order by a;

--test: add index
alter table ltz add index idx(c_tstz1);
show index in ltz;


drop table ltz;

set system parameters 'add_column_update_hard_default=no';
