--+ holdcas on;
create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin', 'jian ye',31,'M');
--TEST Create successfully
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName));
--Test should use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';
--TEST Alter fail 
ALTER  INDEX first_name_lower on t1 where FirstName>'aaa' REBUILD;
--TEST Alter successfully 
ALTER  INDEX first_name_lower on t1(firstname) WHERE LOWER(FirstName)='yin' REBUILD;
--Test should not use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';
--Test should use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin' using index first_name_lower(+);
--TEST Alter successfully 
ALTER  INDEX first_name_lower on t1(LOWER(FirstName)) REBUILD;
--Test should not use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE FirstName ='yin';
--Test should use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';
--TEST Alter successfully 
ALTER  INDEX first_name_lower on t1(FirstName) REBUILD;
--Test should not use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';
--Test should  use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE FirstName ='yin';
--TEST Alter successfully 
ALTER  INDEX first_name_lower on t1(LOWER(FirstName)) REBUILD;
--Test should not use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE FirstName ='yin';
--Test should use index first_name_lower
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';
drop  table t1 ;

commit;
--+ holdcas off;
