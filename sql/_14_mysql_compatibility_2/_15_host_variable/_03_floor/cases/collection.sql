--- collection
prepare st from 'select floor(?)';
execute st using {12,12.2};

create table t1 (s1 set(int, double));

insert into t1 values ({123,1.12312e1});
select floor(s1) from t1;

drop table t1;

select floor({12,12.2});
