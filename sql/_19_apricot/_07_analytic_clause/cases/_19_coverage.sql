
create table t(i1 int, i2 int, i3 int);
insert into t values
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

select * from t order by 1 desc, 2 desc, 3 desc;
select i1,i2,sum(i2) over (partition by i1) from t where i3=5 order by 1, 2 desc;

drop t;

create table t(i1 int, i2 numeric(6,2), i3 int);
insert into t values
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

select avg(i2) over (partition by i1) from t order by i1;
select avg(distinct i2) over (partition by i1) from t order by i1;

drop t;
