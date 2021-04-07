--+ holdcas on;
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin', 'jian ye',31,'M');
--TEST Create successfully
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName));
--Test should use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';
--TEST Alter successfully
ALTER  INDEX first_name_lower on t1 REBUILD;
--TEST Alter failed 
ALTER  INDEX first_name_lower on t1 (trim(FirstName));
--TEST Alter successfully 
ALTER  INDEX first_name_lower on t1 (upper(FirstName))REBUILD;
--Test should not use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';
--Test should use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE upper(FirstName)='yin';
--TEST Create successfully
CREATE INDEX first_name_lower1 ON t1 (LOWER(FirstName));
--TEST Alter failed 
ALTER  INDEX first_name_lower on t1 (LOWER(FirstName)) REBUILD;
drop  table t1 ;

commit;
--+ holdcas off;
