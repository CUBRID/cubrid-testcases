-- 
create table t1 ( i1 integer , i2 integer );
insert into t1 values (1,1),(1,2),(2,3),(2,2),(2,5),(3,5);
select * from t1 order by i1,i2;

select field(i1,i1,i1) from t1 group by field(i1,i1,i1);

drop table t1;

