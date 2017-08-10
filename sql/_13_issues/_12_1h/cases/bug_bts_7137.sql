create table t(i int primary key);
insert into t values(1),(2),(3);
prepare st from 'select * from t where i>? or i<? ';
-- below operation should succeed.
execute st using 5,10;
drop table t;
