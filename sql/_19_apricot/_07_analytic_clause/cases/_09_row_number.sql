
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

-- OVER(PARTITION BY)
select i1,i2,i3,row_number() over (partition by i1,i2,i3) from t order by 1, 2, 3;

-- OVER(ORDER BY)
select i1,i2,i3,row_number() over (order by i1,i2,i3) from t order by 1, 2, 3;


-- OVER(PARTITION BY ORDER BY)
select i1,i2,i3,row_number() over (partition by i1 order by i2,i3) from t order by 1, 2, 3;
select i1,i2,i3,row_number() over (partition by i2 order by i1,i3) from t order by 2, 1, 3;
select i1,i2,i3,row_number() over (partition by i3 order by i1,i2) from t order by 3, 1, 2;
select i1,i2,i3,row_number() over (partition by i1,i2 order by i3) from t order by 1, 2, 3;
select i1,i2,i3,row_number() over (partition by i1,i3 order by i2) from t order by 1, 3, 2;
select i1,i2,i3,row_number() over (partition by i2,i3 order by i1) from t order by 2, 3, 1;

drop t;
