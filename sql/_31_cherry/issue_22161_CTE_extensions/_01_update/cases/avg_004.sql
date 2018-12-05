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
with cte1 as
(
    select col2,avg(col3) as avg_col3 from t group by col2
)   update t,cte1 set t.col5='price high' where t.col2=cte1.col2 and t.col3>cte1.avg_col3;

select col1,col2,col3,col5 from t  order by 1,2;
select col1,col2,col3,col5 from t where col4 is not null;
drop table if exists t;


drop table if exists t;
create table t(col1 int primary key,col2 varchar(50),col3 double,
    col4 timestamp default '2000-10-1 10:00:00' on update current_timestamp,col5 varchar(50));
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

drop view if exists v1;
create view v1 as select * from t;

with cte1 as
(
    select col2,avg(col3) as avg_col3 from t group by col2
)   update v1 set v1.col5='high' where v1.col3 >=(select avg(avg_col3) from cte1);

with cte1 as
(
    select col2,avg(col3) as avg_col3 from t group by col2
)   select avg(avg_col3) from cte1;

select col1,col2,col3,col5 from t  order by 1,2;
select col1,col2,col3,col5 from v1 where col4 is not null;
drop table if exists t;
drop view v1;

