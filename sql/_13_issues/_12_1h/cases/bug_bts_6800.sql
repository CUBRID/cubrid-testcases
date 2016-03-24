create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
CREATE INDEX full_name ON t1 (CONCAT(FirstName,LastName));
CREATE INDEX last_name1 ON t1 (TRIM(LastName));
drop table t1 ;

