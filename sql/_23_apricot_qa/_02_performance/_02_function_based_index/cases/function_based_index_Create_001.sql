--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
--TEST Create successfully
CREATE INDEX last_name_lower ON t1 (LOWER(LastName));
drop INDEX last_name_lower on t1;
--TEST Create successfully
CREATE INDEX last_name ON t1 (LastName);
drop INDEX last_name on t1;
--TEST Create faile
CREATE INDEX last_name ON t1 (LastName(FirstName));
drop INDEX last_name on t1;
--TEST Create successfully
CREATE INDEX last_name_lower ON t1 (LOWER(LastName)ASC);
drop INDEX last_name_lower on t1;
--TEST Create successfully
CREATE INDEX full_name ON t1 (CONCAT(FirstName,LastName));
drop INDEX full_name on t1;
--TEST Create successfully 
CREATE INDEX full_name ON t1 (CONCAT('Mr. ', LastName));
drop INDEX full_name on t1;
CREATE INDEX last_name ON t1 (LastName) where LastName>'0';
--TEST Create successfully 
CREATE INDEX last_name1 ON t1 (TRIM(LastName));
--TEST Create successfully 
CREATE INDEX last_name2 ON t1 (LOWER(LastName));
--TEST Create successfully 
CREATE INDEX last_name3 ON t1 (CONCAT('Mr. ', LastName));
--TEST Create failed
CREATE INDEX last_name4 ON t1(LastName) where LastName >'aaa';
--TEST Create failed 
CREATE INDEX last_name5 ON t1 (LOWER(LastName));
--TEST Create failed 
CREATE reverse INDEX last_name6 ON t1 (LOWER(LastName));
--TEST Create failed 
CREATE unique INDEX last_name7 ON t1 (LOWER(LastName));
--TEST Create failed 
CREATE reverse unique INDEX last_name8 ON t1 (LOWER(LastName));
drop table t1 ;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
