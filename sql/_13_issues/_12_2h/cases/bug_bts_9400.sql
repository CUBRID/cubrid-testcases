--TEST: insert ... select false query


CREATE TABLE t1 (id INT, aaa INT);
CREATE TABLE t2 (id INT, bbb INT);

insert into t1 values(1, 1), (2, 2);
insert into t2 values(1, 1), (2, 3);

INSERT INTO t1 (id)
SELECT t2.id
FROM t2
WHERE
    NOT EXISTS
        (SELECT NULL
         FROM t1
         WHERE t1.aaa = t2.bbb);


select * from t1 order by id desc;

drop table t1, t2;


create table t (a int, b int, c int);
create table s (a int, b int);

insert into s values (0,1);

insert into t (a) select a from s where 1 = 2;
insert into t (a,b) select * from s where 1 = 2;

insert into t (a) select a from s where s.a = (select count (*) from t where 1 = 2);

select * from t;

drop s;
drop t;



