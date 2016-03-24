--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
--TEST Create successfully
CREATE REVERSE INDEX last_name_lower ON t1 (LOWER(LastName));
drop REVERSE INDEX last_name_lower on t1;
--TEST Create successfully
CREATE REVERSE INDEX last_name ON t1 (LastName);
drop REVERSE INDEX last_name on t1;
--TEST Create successfully
CREATE REVERSE INDEX last_name ON t1 (LastName(FirstName));
drop REVERSE INDEX last_name on t1;
--TEST Create successfully?
CREATE REVERSE INDEX last_name_lower ON t1 (LOWER(LastName)ASC);
drop REVERSE INDEX last_name_lower on t1;
--TEST Create successfully
CREATE REVERSE INDEX full_name ON t1 (CONCAT(FirstName,LastName));
drop REVERSE INDEX full_name on t1;
--TEST Create successfully 
CREATE REVERSE INDEX full_name ON t1 (CONCAT('Mr. ', LastName));
drop  table t1 ;
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
--TEST Create successfully 
CREATE INDEX last_name_lower ON t1 (LOWER(LastName));
--TEST Create successfully 
CREATE INDEX last_name_lower ON t1 (LOWER(LastName)desc);
drop  table t1 ;
set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
