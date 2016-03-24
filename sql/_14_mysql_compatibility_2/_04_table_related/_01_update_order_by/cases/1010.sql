-- UPDATE ... ORDER BY    + on multiple tables

-- same rows name, data values set so that only one table is updated
create table t1 (i1 integer ,i2 integer);
create table t2 (i1 integer ,i2 integer);
insert into t1 values (4,4), (1,7) , (7,1),(2,6), (3,5), (6,2),(5,3);
insert into t2 values (40,40), (10,70) , (70,10),(20,60), (30,50), (60,20),(50,30);
select * from t1 order by 1,2;
select * from t2 order by 1,2;

update (t1,t2) set i1=0 order by i2 limit 3;

select * from t1 order by 1,2;
select * from t2 order by 1,2;

drop t1;
drop t2;



-- different rows name
create table t1 (i1 integer ,i2 integer);
create table t2 (i_1 integer ,i_2 integer);
insert into t1 values (4,4), (1,7) , (7,1),(2,6), (3,5), (6,2),(5,3);
insert into t2 values (40,40), (10,70) , (70,10),(20,60), (30,50), (60,20),(50,30);
select * from t1 order by 1,2;
select * from t2 order by 1,2;

update (t1,t2) set i1=0 order by i2 limit 3;

select * from t1 order by 1,2;
select * from t2 order by 1,2;


drop t1;
drop t2;


-- same rows name -- mixed data values
create table t1 (i1 integer ,i2 integer);
create table t2 (i1 integer ,i2 integer);
insert into t1 values (40,40), (1,7) , (7,1),(2,6), (3,5), (60,20),(5,3);
insert into t2 values (4,4), (10,70) , (70,10),(20,60), (30,50), (6,2),(50,30);
select * from t1 order by 1,2;
select * from t2 order by 1,2;

update (t1,t2) set i1=0 order by i2 limit 5;

select * from t1 order by 1,2;
select * from t2 order by 1,2;


drop t1;
drop t2;

