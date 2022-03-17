--- string 

create table t1 (s1 varchar(20), sn1 nchar varying(20));

insert into t1 values (2.00123e1,3);
select -(s1) from t1;
select -(sn1) from t1;

truncate table t1;
insert into t1 values ('asd',n'asd');
select -(s1) from t1;
select -(sn1) from t1;

drop table t1;

select (-('123'));

select (-(n'123'));

select (-('asd'));

select (-(n'asd'));

prepare st from 'select -(?)';
execute st using '2001-10-11';

prepare st from 'select -(?)';
execute st using '2001';

prepare st from 'select -(?)';
execute st using '2.0011e1';

prepare st from 'select -(?)';
execute st using '2001.12';

prepare st from 'select -(?)';
execute st using 'asd';
