create table t1(v int);
insert into t1 values(0),(1),(2);

SELECT * FROM t1 WHERE v IN (SELECT (1 = 1)) order by 1; 
SELECT * FROM t1 WHERE v IN (SELECT ('aaa' LIKE 'bbb'))  order by 1; 
SELECT * FROM t1 WHERE EXISTS (SELECT (1 < ALL{1,3,4} )) order by 1; 
SELECT * FROM t1 WHERE EXISTS (select NULL) order by 1;
SELECT * FROM t1 WHERE EXISTS (NULL) order by 1;
select * from t1 where exists(select ('c' rlike 'ab')) order by 1;
select * from t1 where exists(select 1 from db_class where 1 between 10 and 100) order by 1;
select * from t1 where exists(select 1 from db_class where 11 between 10 and 100) order by 1;

drop t1;
create table testtbl(id int,v varchar(5));
insert into testtbl values(1,'0'),(2,'1');
select * from testtbl where v in (select ('a' rlike 'Ms')) order by 1;
select * from testtbl where isnull(v)<>0 order by 1;
update testtbl set v=NULL where id=2;
select * from testtbl where isnull(v)<>0 order by 1;
insert into testtbl values(1,'0'),(2,'1');
select * from testtbl where v in (select ('a' not like '%a%')) order by 1;
select * from testtbl where v in (select ('a' like '%a%')) order by 1;

drop testtbl;
create table t1(v int);
insert into t1 values(0),(1),(2);

prepare st from 'SELECT * FROM t1 WHERE v IN (SELECT (? LIKE ?));';
execute st using 'a','aaa';
execute st using 'aaa','aaa';

deallocate prepare st;

drop t1;
