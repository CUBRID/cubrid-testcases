drop table if exists t1;
create table t1 (id int primary key, a int, b int, c int)
PARTITION BY RANGE ( id ) (
PARTITION p1 VALUES LESS THAN ( 100),
PARTITION p2 VALUES LESS THAN ( 100000 )
);

insert into t1 values(1,2,3,4);
insert into t1 values(101,202,303,404);

create index i_t1_abc on t1(a,b,c);

select  * from t1 partition(p1) s1, t1 partition(p2) s2 where s1.b<10 and s1.b=s2.b;   

WITH cte_febDNYkbe AS
(
 select * from t1 partition(p1) s1, t1 partition(p2) s2 where s1.b<10 and s1.b=s2.b
)
select * from cte_febDNYkbe;

WITH cte_febDNYkbe(id, a,b,c,id2,aa,bb,cc) AS
(
 select * from t1 partition(p1) s1, t1 partition(p2) s2 where s1.b<10 and s1.b=s2.b
)
select * from cte_febDNYkbe;

WITH cte_r6EFC8bYn AS
(
 select ('abc' rlike'abc'), ('ABC' rlike 'abc')
)
select * from cte_r6EFC8bYn;

WITH cte_r6EFC8bYn(a,b) AS
(
 select ('abc' rlike'abc'), ('ABC' rlike 'abc')
)
select * from cte_r6EFC8bYn;

drop table t1;
drop table if exists t1_ns;
drop table if exists t2_ns;

create table t1_ns(a int, b int);

create table t2_ns like t1_ns;

insert into t1_ns values(1,2);

insert into t1_ns values(null,3);

insert into t1_ns values(5,6);

insert into t2_ns values(1,2);

insert into t2_ns values(4,3);

insert into t2_ns values(7,8);

WITH cte_LDoFDs AS
(
select t1_ns.*,t2_ns.* from t1_ns left outer join t2_ns on t1_ns.a=t2_ns.a and t1_ns.b=t2_ns.b where 1=1
)
select * from cte_LDoFDs;


WITH cte_LDoFDs(a,b,c,d) AS
(
select t1_ns.*,t2_ns.* from t1_ns left outer join t2_ns on t1_ns.a=t2_ns.a and t1_ns.b=t2_ns.b where 1=1
)
select * from cte_LDoFDs order by 1,2,3;


drop table if exists t1_ns;
drop table if exists t2_ns;

