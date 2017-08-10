--TEST: Throw "ERROR: Execute: Query execution failure #1029. " when update multiple tables

autocommit off;

drop table if exists t1,t3,t11,t12,t13,t21,t31,t2;
CREATE TABLE t1 (a int , b int );
CREATE TABLE t2 (a int , b int );
INSERT INTO t1 VALUES (1, 1), (2, 1), (3, 1);
INSERT INTO t2 VALUES (1, 1), (3, 1);

commit;

SELECT t1.a, t1.b, t2.a, t2.b FROM t1 LEFT JOIN t2 ON t1.a = t2.a WHERE t1.b = 1 AND t2.b = 1 OR t2.a IS NULL order by 1;
--below sql will fail in CUBRID and throw exception "ERROR: Execute: Query execution failure #1029.". MySQL will success.
update t1 left join t2 on t1.a=t2.a set t1.b=2, t2.b=2 where t1.b=1 and t2.b=1 or t2.a is NULL;
select if(t1.b=2 and t2.b=2, 'ok', 'nok') from t1, t2 where t1.a=t2.a;
rollback;


insert into t1 values(2, 1);
SELECT t1.a, t1.b, t2.a, t2.b FROM t1 LEFT JOIN t2 ON t1.a = t2.a WHERE t1.b = 1 AND t2.b = 1 OR t2.a IS NULL order by 1;
update t2 right outer join t1 on t1.a=t2.a set t1.a=t2.a, t1.b=t2.b, t2.a=t1.a, t2.b=t1.b where t1.b=1 or t2.b is null;
select if(count(*)=2, 'ok', 'nok') from t1 where a is null;
select if(b=1, 'ok', 'nok') from t2;
rollback;

drop table t1, t2;
commit;


autocommit on;
