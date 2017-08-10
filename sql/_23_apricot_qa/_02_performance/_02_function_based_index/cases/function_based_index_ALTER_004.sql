--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin', 'jian ye',31,'M');
--TEST Create successfully
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName));
--TEST Alter successfully 
ALTER  REVERSE INDEX first_name_lower ON t1 (LOWER(LastName)) REBUILD;
--TEST Alter successfully 
ALTER  REVERSE INDEX first_name_lower ON t1 (LOWER(FirstName)) REBUILD;
--TEST Alter successfully 
ALTER  INDEX first_name_lower ON t1 (LOWER(LastName)) REBUILD;
drop  table t1 ;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
