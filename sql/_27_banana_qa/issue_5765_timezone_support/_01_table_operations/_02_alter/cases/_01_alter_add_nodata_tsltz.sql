--add TIMESTAMPLTZ columns, using alter ... add statement, no data in the table

set system parameters 'add_column_update_hard_default=no';

drop table if exists ltz;
create table ltz(a int);

--test: add column with default
alter table ltz add c_tsltz1 timestamp with local time zone default '2003-01-01 2:00:00 -8:00';
desc ltz;

--test: add column with not null, without default
alter table ltz add c_tsltz2 timestamp with local time zone not null;
desc ltz;

--test: add column with unique
alter table ltz add c_tsltz3 timestamp with local time zone unique;
show columns in ltz;

--test: add column with unique and not null
alter table ltz add c_tsltz4 timestamp with local time zone unique not null;
show columns in ltz;

--test: add column with unique and default
alter table ltz add c_tsltz5 timestamp with local time zone default '2003-01-01 2:00:00 -8:00' unique;
show columns in ltz;

--test: rename column
alter table ltz rename column c_tsltz5 as renamed;
desc ltz;

--test: add column with primary key
alter table ltz add c_tsltz5 timestamp with local time zone primary key;
show columns in ltz;

--test: drop constraint
alter table ltz drop constraint u_ltz_c_tsltz4;
desc ltz;

--test: drop primary key
alter table ltz drop primary key;
desc ltz;
 
--test: add constraint
alter table ltz add constraint pk primary key(c_tsltz1);
desc ltz;

--test: alter column set default
alter table ltz alter column c_tsltz1 set default now();
desc ltz;

--test: add index
alter table ltz add index idx(c_tsltz2);
show index in ltz;

--test: drop index
alter table ltz drop index idx;
show index in ltz;


drop table ltz;


