drop table if exists t,foo;
create table t(i int primary key,j varchar(50),k double);
insert into t values(1,'A',90);
insert into t values(2,'A',95);
insert into t values(3,'B',88);
insert into t values(4,'D',60);
insert into t values(5,'C',78);
insert into t values(6,'D',30);
insert into t values(7,'B',85);

create table foo as select * from t;

with cte1 as
(
 select avg(k) as avg_of_total from t
),
cte2 as
(
 select j,avg(k) as avg_of_level from t group by j
),
cte3 as
(
 select j from t where k>=80
),
cte4 as
(select t.* from t,cte2 where t.j=cte2.j and t.k>=cte2.avg_of_level
)
delete from foo where i in (select i from cte4) and j in (select j from cte3) and k>=(select avg_of_total from cte1);

select * from foo;


