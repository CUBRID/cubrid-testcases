--+ holdcas on;

drop table if exists t1;
create table t1(a int,b int);
insert into t1 values(1,1);
insert into t1 values(2,null);
insert into t1 values(3,null);
insert into t1 values(4,2);
insert into t1 values(5,1);
insert into t1 values(6,1);


select sum(a) from t1 group by b limit 1 order by 1;

select sum(a) from t1 where a>= (
select sum(a) as a from t1 group by b order by a asc limit 1)  order by 1;


select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 where a> ( select sum(a) from t1 where a> (
select sum(a) from t1 
)group by b limit 1)group by b limit 1)group by b limit 1
)group by b limit 1)group by b limit 1)group by b limit 1
)group by b limit 1)group by b limit 1)group by b limit 1
)group by b limit 1)group by b limit 1)group by b limit 1
)group by b limit 1)group by b limit 1)group by b limit 1
)group by b limit 1)group by b limit 1)group by b limit 1
)group by b limit 1)group by b limit 1)group by b limit 1
)group by b limit 1)group by b limit 1)group by b limit 1
)group by b limit 1)group by b limit 1)group by b limit 1
)group by b limit 1)group by b limit 1)group by b limit 1)  order by 1;

drop table if exists t1;


--+ holdcas off;
commit;
