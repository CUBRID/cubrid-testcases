--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin', 'jian ye',31,'M');
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName));
create  INDEX first_name_lower1 on t1(firstname) WHERE LOWER(FirstName)='yin';
--TEST Alter failed 
ALTER  INDEX first_name_lower on t1(firstname) WHERE LOWER(FirstName)='yin' REBUILD;
--TEST Alter failed 
alter  INDEX first_name_lower1 on t1(firstname) REBUILD;
--TEST Alter successfully
alter  INDEX first_name_lower1 on t1 REBUILD;
--TEST Alter failed 
ALTER  INDEX first_name_lower on t1(FirstName) REBUILD;
--TEST Alter failed
ALTER  INDEX first_name_lower on t1(FirstName desc) REBUILD;
--TEST Alter successfully
ALTER  INDEX first_name_lower on t1 REBUILD;
drop  table t1 ;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
