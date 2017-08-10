create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
CREATE INDEX last_name ON t1 (LastName);
CREATE unique INDEX last_name1 ON t1 (LOWER(LastName));
CREATE INDEX last_name1 ON t1 (LOWER(LastName));
drop table t1 ;

create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
alter table t1 add unique index idx (FirstName);
alter table t1 add unique index idx1(LOWER(LastName));
CREATE INDEX last_name ON t1 (LastName);

drop table t1 ;

