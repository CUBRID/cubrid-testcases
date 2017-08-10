--create table with TIMESTAMPLTZ columns with constraints


--test: default
drop table if exists ltz;
create table ltz(c_tsltz timestamp with local time zone default sys_timestamp);
desc ltz;
drop table ltz;

--test: shared
create table ltz(c_tsltz timestamp with local time zone shared '2000-12-12 12:00:00 AM +02:00');
desc ltz;
drop table ltz;

--test: [er] auto_increment
create table ltz(c_tsltz timestamp with local time zone auto_increment);
desc ltz;
drop table ltz;

--test: not null
create table ltz(c_tsltz timestamp with local time zone not null);
show columns in ltz;
drop table ltz;

--test: unique
create table ltz(c_tsltz timestamp with local time zone unique);
show columns in ltz;
drop table ltz;

--test: primary key
create table ltz(c_tsltz timestamp with local time zone primary key);
show columns in ltz;
drop table ltz;

--test: foreign key
create table a_ltz(c_tsltz timestamp with local time zone primary key);
create table b_ltz(c_tsltz timestamp with local time zone primary key, constraint fk_id foreign key (c_tsltz) references a_ltz(c_tsltz));
desc b_ltz;
show index in b_ltz;
drop table a_ltz, b_ltz cascade constraints;

--test: reuse_oid
create table ltz(c_tsltz timestamp with local time zone not null) reuse_oid;
show columns in ltz;
drop table ltz;


