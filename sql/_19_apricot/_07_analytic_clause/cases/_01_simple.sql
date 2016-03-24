
create table t(i1 int, i2 int);
insert into t values
(1,1),
(1,2),
(1,3),
(2,1),
(2,2),
(2,3),
(2,4),
(3,1),
(3,2),
(3,3);

select i1,i2,count(*) over (partition by i1) as cnt1, sum(i2) over (partition by i1) as s1,
max(i2) over (partition by i1) as m1, count(*) over (partition by i1 order by i2) as cnt2,
sum(i2) over (partition by i1 order by i2) as s2, max(i2) over (partition by i1 order by i2) as m2 from t;

drop t;

create table t2(i1 int, i2 int, i3 int);
insert into t2 values
(1,1,1),
(1,1,2),
(1,2,1),
(1,2,2),
(1,2,3),
(2,1,1),
(2,1,2),
(2,1,3),
(2,1,4),
(2,2,1),
(2,2,2),
(2,3,1),
(2,3,2),
(2,3,3);

select i1,i2,sum(distinct i2) over (partition by i1 order by i2) from t2;
select i1,i2,sum(i2) over (partition by i1 order by i2) from t2;
select i1,i2,sum(distinct i2) over (order by i1,i2) from t2;
select i1,i2,sum(i2) over (order by i1,i2) from t2;
select i1,i2,sum(distinct i2) over (partition by i1) as s1, sum(distinct i1) over (partition by i2) as s2 from t2;
select i1,i2,sum(distinct i1) over (partition by i2) as s2, sum(distinct i2) over (partition by i1) as s1 from t2;

drop t2;
