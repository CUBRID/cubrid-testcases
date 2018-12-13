drop table if exists t1;

create table t1 (FirstName varchar(20),LastName varchar(20),Age int,gender char (1));

insert into t1 value('yin', 'jian ye',31,'M');

--TEST Create successfully
CREATE INDEX first_name_lower ON t1 (LOWER(FirstName)) with online;

--Test should use index first_name_lower
--@queryplan
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';

--TEST Alter successfully
ALTER  INDEX first_name_lower on t1 INVISIBLE;

show index from t1;

-- Keep the same status of visiblilitshow index from t1;
ALTER  INDEX first_name_lower on t1 REBUILD;

show index from t1;

--Test SHOULD NOT USE index first_name_lower
--@queryplan
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';

--TEST Alter failed
ALTER  INDEX first_name_lower on t1 (trim(FirstName));

--TEST Alter successfully
ALTER  INDEX first_name_lower on t1 (upper(FirstName)) REBUILD;

-- CBRD-22653 by design, upper(FirstName) will be ignored.
show index from t1;

--Test should not use index first_name_lower
--@queryplan
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';

--Test should not use index first_name_lower
--@queryplan
SELECT /*+ recompile */* FROM t1 WHERE upper(FirstName)='yin';

ALTER  INDEX first_name_lower on t1 VISIBLE;

show index from t1;

--Test should use index first_name_lower
--@queryplan
SELECT /*+ recompile */* FROM t1 WHERE LOWER(FirstName)='yin';

drop  table t1 ;

