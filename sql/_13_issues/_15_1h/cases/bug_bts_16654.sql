-- basicly ok
select 'basic--ok';
drop table if exists t1;
create table t1(a int);
insert into t1 values(1);
insert into t1 values(2);
alter table t1 change a a int unique;
alter table t1 change a a int primary key;
desc t1;


--- basic nok
select 'basic nok';
drop table if exists t1;
create table t1(a int unique);
insert into t1 values(NULL);
insert into t1 values(1);
alter table t1 change a a int primary key;
desc t1;

--- muti rows
select 'muti rows';
drop table if exists t1;
create table t1(a int, b int, c string);
insert into t1 values(1,1, 'a');
insert into t1 values(2,2, 'b');
alter table t1 add constraint u1 unique(a,b,c);
insert into t1 values(3,3, NULL);
alter table t1 add constraint pk1 primary key(a,b,c);
insert into t1 values(4,4, NULL);
desc t1;
delete from t1 where c is null;
alter table t1 add constraint pk1 primary key(a,b,c);
desc t1;
insert into t1 values(3,3, NULL);
alter table t1 drop primary key;
insert into t1 values(3,3, NULL);
desc t1;

-- server insert
select 'server insert';
drop table if exists t1;
create table t1(a int, b int, c string);
insert into t1 values(1,1, 'a');
insert into t1 values(2,2, 'b');
alter table t1 add constraint u1 unique(a,b,c);
alter table t1 add constraint pk1 primary key(a,b,c);
drop table if exists t2;
create table t2(a int, b int, c string);
insert into t2 values(3,3, NULL);
insert into t1 select * from t2;

drop table if exists t1;
create table t1(a int primary key unique);

drop table if exists t1;
create table t1(a string);
insert into t1 values(NULL);
alter table t1 change a a int not null;
alter table t1 change a a int primary key;
select * from t1;

drop table if exists t1;
create table t1(a int unique);
insert into t1 values(NULL);
insert into t1 values(NULL);
alter table t1 change a a int primary key;
select * from t1;
desc t1;

drop  t1,t2;

