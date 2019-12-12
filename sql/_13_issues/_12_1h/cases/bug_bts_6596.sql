drop table if exists t1;
create table t1 (a int);
insert into t1 values (1);
-- below query will return a record.
SELECT a from t1 UNION SELECT a from t1 LIMIT 1;
--We expect below query return that record also. In fact, CUBRID returned nothing.
SELECT * FROM ((SELECT a from t1) UNION (SELECT a from t1) LIMIT 1) s1;


SELECT a from t1 UNION SELECT a from t1 LIMIT 1;
--We expect below query return that record also. In fact, CUBRID returned nothing.
SELECT * FROM ((SELECT a from t1) UNION (SELECT a from t1) LIMIT 1) s1;

drop table t1;

