drop table if exists t1;
-- SELECT  ... LIMIT  (without FROM) : 

create table t1 ( i1 integer , i2 integer );
insert into t1 values (1,1),(1,2),(2,3),(2,2),(2,5),(3,5);

select * from t1 order by i1,i2;

-- without 'from' - should fail:
select * limit 2;

----- where + limit  : SELECT COUNT() , because the output of columns is not 
---  the same for each execution, but the count shoud be.. 
select count(*) from t1 where i1<3 limit 2;
-- should fail:
select * from t1 where inst_num()<2 limit 2;

-- group by
select i1 from t1 group by i1 limit 2;
-- group by.. having + limit
select i1,sum(i2) from t1 group by i1 having i1<3 limit 1;
-- should fail:
select * from t1 group by i1 having groupby_num()<2 limit 2;

-- order by .. + limit
--select * from t1 order by i1 for i1>1 limit 2;
-- should fail:
select * from t1 order by i1 for orderby_num()>1 limit 2;




-- multiple LIMIT values

-- without 'from' - should fail:
select * limit 2,1;

-- where + limit
select count(*) from t1 where i1<3 limit 2,1;
-- should fail:
select * from t1 where inst_num()<2 limit 2,1;

-- group by
select i1 from t1 group by i1 limit 2,1;
-- group by.. having + limit
select * from t1 group by i1 having i1<3 limit 2,1;
-- should fail:
select * from t1 group by i1 having groupby_num()<2 limit 2,1;

-- order by .. + limit
select * from t1 order by i1 for i1>3 limit 2,1;
-- should fail:
select * from t1 order by i1 for orderby_num()>1 limit 2,1;
drop table t1;
