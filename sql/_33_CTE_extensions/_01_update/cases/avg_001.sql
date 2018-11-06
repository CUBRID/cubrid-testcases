drop table if exists t;
create table t(col1 int primary key,col2 varchar(50),col3 double,col4 timestamp default '2000-10-1 10:00:00' on update current_timestamp,col5 char(20));
insert into t values(1,'A',10.0,null,null);
insert into t values(2,'A',11.0,null,null);
insert into t values(3,'A',12.0,null,null);
insert into t values(4,'B',20.0,null,null);
insert into t values(5,'A',13.0,null,null);
insert into t values(6,'A',33.0,null,null);
insert into t values(7,'C',15.0,null,null);
insert into t values(8,'B',19.0,null,null);
insert into t values(9,'C',50.0,null,null);
insert into t values(10,'C',100.0,null,null);
with cte1(a,b) as
(
    select col2,avg(col3) from t group by col2
)   update t,cte1 set col5='price high' where col2=a and col3>b;

with cte1(a,b) as
(
    select col2,avg(col3) from t group by col2
) select * from cte1 order by a,b;


select col1,col2,col3,col5 from t  order by 1,2;
select col1,col2,col3,col5 from t where col4 is not null;
drop table if exists t;
