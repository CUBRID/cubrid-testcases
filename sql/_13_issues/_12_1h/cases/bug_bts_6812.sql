create table t(a double);
create  index idx on t(COS(a));
insert into t values(0);
insert into t values(pi()*2);
alter  index idx on t(COS(a),a) REBUILD;
insert into t values(pi()*2);
drop table t;

create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin', 'jian ye',31,'M');
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName));
ALTER  INDEX first_name_lower on t1 (upper(FirstName))REBUILD;
drop  table t1 ;