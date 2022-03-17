--- date

create table t1 (d1 date);

insert into t1 values (date'2001-10-11');
select trunc(d1,1) from t1;

select trunc(1.23,d1) from t1;

drop table t1;



select trunc(date'2001-10-10',1);

select trunc(1.123,date'2001-10-10');

prepare st from 'select trunc(?,?)';
execute st using date'2001-10-11',1;

prepare st from 'select trunc(?,?)';
execute st using 1.123,time'10:11:12';
