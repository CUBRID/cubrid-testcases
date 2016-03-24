-- select GROUP BY .. WITH ROLLUP  

create table t1 ( i1 integer , i2 integer );

insert into t1 values (1,1),(1,2),(2,3),(2,2),(2,5),(3,5);

select * from t1 order by i1,i2;


-- the statement should fail
select sum(i2) from t1 with rollup;

select sum(i2) from t1 group by i2 with rollup;

select stddev(i2) from t1 group by i2 with rollup;

select stddev(i2) from t1 group by i2 with rollup having i2>1;

select stddev(i2) from t1 group by i2 with rollup having i2>1 limit 4;

select stddev(i2) from t1 group by i2 with rollup having i2>(select max(i1) from t1);

drop table t1;