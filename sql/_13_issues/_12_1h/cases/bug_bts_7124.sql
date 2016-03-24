-- verify different expression as default values
create table foo (a timestamp default sys_timestamp);
drop foo;

create table foo (a datetime default sys_timestamp);
drop foo;

create table foo (a timestamp default sys_timestamp + 3600);
drop foo;

create table foo (a string default user);
drop foo;

create table foo (a int default length(user));
drop foo;

create table foo (a int default -unix_timestamp());
drop foo;

create table foo (a float default exp(current_timestamp) + 17 * 2 + length(user));
drop foo;

create table foo (a float default exp(3) + 17 * 2 + length('some random string'));
drop foo;


-- verify alter
create table foo (a int, b timestamp, c varchar(255));
desc foo;

-- should report an error
alter table foo alter column b set default sys_timestamp + 5;
-- should work
alter table foo alter column a set default 1, alter column b set default sys_timestamp, alter column c set default user;
desc foo;
drop foo;

create table foo (a int, b timestamp, c varchar(255));
desc foo;

-- should report an error
alter table foo change column b b timestamp default sys_timestamp + 5;
-- should work
alter table foo change column a a int default 1;
alter table foo change column b b timestamp default sys_timestamp;
alter table foo change column c c varchar(255) default user;

-- should report an error
alter table foo add column e timestamp default sys_timestamp + 5;
-- should work
alter table foo add column d int default 1;
alter table foo add column e timestamp default sys_timestamp;
alter table foo add column f varchar(255) default user;
desc foo;
drop foo;

create table foo (a int, b timestamp, c varchar(255));
desc foo;

-- should report an error
alter table foo modify column b timestamp default sys_timestamp + 5;
-- should work
alter table foo modify column a int default 1;
alter table foo modify column b timestamp default sys_timestamp;
alter table foo modify column c varchar(255) default user;

desc foo;
drop foo;