--- number


create table t1 (d1 double, i1 int, n1 numeric(10,3));

insert into t1 values (2.00123e1,3,100.21);
select ceil(d1) from t1;
select ceil(n1) from t1;
select ceil(i1) from t1;
drop table t1;


select ceil(4);

select ceil(4.4);

select ceil(4.001e1);


prepare st from 'select ceil(?)';
execute st using 4;
deallocate prepare st;

prepare st from 'select ceil(?)';
execute st using 4.12;
deallocate prepare st;

prepare st from 'select ceil(?)';
execute st using 4.001123e1;
deallocate prepare st;
