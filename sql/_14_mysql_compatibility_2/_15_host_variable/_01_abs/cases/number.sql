--- number


create table t1 (d1 double, i1 int, n1 numeric(10,3));

insert into t1 values (2.00123e1,3,100.21);
select abs(d1) from t1;
select abs(n1) from t1;
select abs(i1) from t1;
drop table t1;


select abs(4);

select abs(4.4);

select abs(4.001e1);


prepare st from 'select abs(?)';
execute st using 4;

prepare st from 'select abs(?)';
execute st using 4.12;

prepare st from 'select abs(?)';
execute st using 4.001123e1;
