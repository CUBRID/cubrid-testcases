create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));
insert into t1 value('yin', 'jian ye',31,'M');
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName));
ALTER  INDEX first_name_lower on t1 REBUILD;
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin' using index first_name_lower(+);
drop  table t1 ;

