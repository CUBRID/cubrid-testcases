create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin', 'jian ye',31,'M');
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName));
--TEST Alter fail 
ALTER  INDEX first_name_lower on t1(firstname) WHERE LOWER(FirstName)='yin' REBUILD;
--TEST Alter fail
ALTER  INDEX first_name_lower on t1(LOWER(FirstName)) REBUILD;
--TEST Alter successfully 
ALTER  INDEX first_name_lower on t1 REBUILD;

drop table t1;
