--create table with DATETIMELTZ columns with constraints


--test: default
drop table if exists ltz;
create table ltz(c_dtltz datetime with local time zone default sys_datetime);
desc ltz;
drop table ltz;

--test: shared
create table ltz(c_dtltz datetime with local time zone shared '2000-12-12 12:00:00.123 AM +02:00');
desc ltz;
drop table ltz;

--test: [er] auto_increment
create table ltz(c_dtltz datetime with local time zone auto_increment);
desc ltz;
drop table ltz;

--test: not null
create table ltz(c_dtltz datetime with local time zone not null);
show columns in ltz;
drop table ltz;

--test: unique
create table ltz(c_dtltz datetime with local time zone unique);
show columns in ltz;
drop table ltz;

--test: primary key
create table ltz(c_dtltz datetime with local time zone primary key);
show columns in ltz;
drop table ltz;

--test: foreign key
create table a_ltz(c_dtltz datetime with local time zone primary key);
create table b_ltz(c_dtltz datetime with local time zone primary key, constraint fk_id foreign key (c_dtltz) references a_ltz(c_dtltz));
desc b_ltz;
show index in b_ltz;
drop table a_ltz, b_ltz cascade constraints;

--test: reuse_oid
create table ltz(c_dtltz datetime with local time zone not null) reuse_oid;
show columns in ltz;
drop table ltz;


