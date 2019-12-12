drop table if exists t2;
create table t2(i int,b int);
insert into t2 values(1,3),(2,3),(3,3),(4,3),(5,3),(6,3),(7,3),(8,3),(9,3);

(select i from t2 where i>2 order by i limit 6) union all (select i from t2 where i>7 order by i limit 1,2); 
(select i from t2 where i>2 order by i limit 6) union all (select i from t2 where i>7 order by i limit 1,2) limit 1,5;
(select i from t2 where i>2 order by i limit 6) intersect (select i from t2 where i>7 order by i limit 1,2); 
(select i from t2 where i>2 order by i limit 6) intersect (select i from t2 where i>7 order by i limit 1,2) limit 1,5;
(select i from t2 where i>2 order by i limit 6) intersect (select i from t2 where i>6 order by i limit 1,2);
(select i from t2 where i>2 order by i limit 6) difference (select i from t2 where i>7 order by i limit 1,2); 
(select i from t2 where i>2 order by i limit 6) difference (select i from t2 where i>7 order by i limit 1,2) limit 1,5;

--error
select i from t2 where i>2 order by i limit 6 union all select i from t2 where i>7 order by i limit 1,2;
--error
select i from t2 where i>2 order by i limit 6 intersect select i from t2 where i>7 order by i limit 1,2;
--error
select i from t2 where i>2 order by i difference select i from t2 where i>7 order by i limit 1,2;
--error
select i from t2 where i>2 order by i limit 6 union all select i from t2 where i>7;
--error
select i from t2 where i>2 order by i intersect select i from t2 where i>7;
--error
select i from t2 where i>2 order by i limit 6 difference select i from t2 where i>7;


select i from t2 where i>2 union all select i from t2 where i>7 order by i limit 6;
select i from t2 where i>2 union all select i from t2 where i>7 order by i DESC limit 6;
select i from t2 where i>2 union all select i from t2 where i>7 union all select i from t2 where i<3 order by i limit 6;
select i from t2 where i>2 union all select i from t2 where i>7 difference select i from t2 where i<3 order by i limit 6;

--error
select i from t2 where i>2 and i <6 union all select i from t2 where i>7 order by i union all select i from t2 where i<3;
--error
select i from t2 where i>2 order by i union all select i from t2 where i>7 union all select i from t2 where i<3;

(select i from t2 where i>2 order by i limit 3) difference select i from t2 where i>7;
(select i from t2 where i>2 order by i limit 2) difference select i from t2 where i>7 limit 3;
(select i from t2 where i>2 order by i limit 5) difference select i from t2 where i>7 limit 3;
(select i from t2 where i>2 order by i limit 6) difference select i from t2 where i>7 limit 3 union all select i from t2 where i > 6 order by i desc;

drop table t2;
