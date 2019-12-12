--+ holdcas on;
set  system parameters 'dont_reuse_heap_file=yes';
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
--TEST Create successfully
CREATE REVERSE UNIQUE  INDEX last_name_lower ON t1 (lower(LastName));
insert into t1 value('yin', 'jianye',31,'M');
--test insert failed
insert into t1 value('yin', 'JianYe',31,'M');
drop REVERSE UNIQUE INDEX last_name_lower on t1;
--test insert successfully
insert into t1 value('yin', 'JianYe',31,'M');
--TEST Create failed
CREATE UNIQUE  INDEX last_name_lower ON t1 (lower(LastName));
--TEST Create successfully
CREATE UNIQUE  INDEX last_name ON t1 (LastName);
drop UNIQUE INDEX last_name on t1;
--TEST Create failed
CREATE UNIQUE  INDEX last_name ON t1 (LastName(FirstName));

--TEST Create successfully
CREATE UNIQUE  INDEX full_name ON t1 (CONCAT(FirstName,LastName));
drop UNIQUE INDEX full_name on t1;
--TEST Create successfully 
CREATE UNIQUE  INDEX full_name ON t1 (CONCAT('Mr. ', LastName));
drop  table t1 ;

set  system parameters 'dont_reuse_heap_file=no';
commit;
--+ holdcas off;
