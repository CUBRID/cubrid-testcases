
--+ holdcas on;

drop table if exists t1;
CREATE TABLE t1 (a int , b int , PRIMARY KEY (a, b));
--CUBRID will return "Missing value for attribute "b" with the NOT NULL constraint.". But MySQL will give a default  zero value for b column.
INSERT INTO t1 (a) SELECT 1;

drop table if exists t1;

--+ holdcas off;
commit;
