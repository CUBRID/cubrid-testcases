--- collection
prepare st from 'select trunc(?,?)';
execute st using {12.2},1;
deallocate prepare st;

create table t1 (s1 set(double));

insert into t1 values ({1.12312e1});
select trunc(s1,1) from t1;

drop table t1;

select trunc({12.2},1);
