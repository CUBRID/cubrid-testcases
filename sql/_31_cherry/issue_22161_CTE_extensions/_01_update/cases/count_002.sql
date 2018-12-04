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
    select col2,count(col3) from t group by col2
)   update t inner join cte1 on col2=a set col5=b;

select col1,col2,col3,col5 from t where col4 is not null;
drop table if exists t;


create table t(col1 int primary key,col2 varchar(50),col3 double,col4 timestamp on update current_timestamp);
insert into t values(1,'A',10.0,null);
insert into t values(2,'A',11.0,null);
insert into t values(3,'A',12.0,null);
insert into t values(4,'B',20.0,null);
insert into t values(5,'A',13.0,null);
insert into t values(6,'A',33.0,null);
insert into t values(7,'C',15.0,null);
insert into t values(8,'B',19.0,null);
insert into t values(9,'C',50.0,null);
insert into t values(10,'C',100.0,null);

drop table if exists t2;
create table t2(i int,j varchar(50),k int);

insert into t2(i) select rownum from db_root connect by level<=10;


with cte1(a,b) as
(
    select col2,count(col3) from t group by col2
) update t inner join cte1 inner join t2 on col2=a and i=col1 set j=a,k=b;


with cte1(a,b) as
(
    select col2,count(col3) from t group by col2
)   update t inner join cte1 inner join t2 on col2=a and i=col1 set j=a,k=b;



with cte1(a,b) as
(
    select col2,count(col3) from t group by col2
)   update t inner join cte1 inner join t2 on col2=a and i=col1 set j=a,k=b;


select *  from t2 order by 1,2,3;
drop table if exists t,t2;





