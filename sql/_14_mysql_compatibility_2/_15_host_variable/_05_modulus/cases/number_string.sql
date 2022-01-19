-- MOD (number , string)
create table t1 (s1 varchar(10),sn1 nchar varying(10), i2 int);

insert into t1 values ('4',n'4',2);
insert into t1 values (NULL,n'4',2);
insert into t1 values ('4',n'2',NULL);
insert into t1 values ('4a',n'2',2);
insert into t1 values ('4',n'2a',2);
select s1,sn1,i2, mod(s1,i2) from t1 order by 1,2,3,4;
select s1,sn1,i2, mod(i2,sn1) from t1 order by 1,2,3,4;
select s1,sn1,i2, mod(s1,sn1) from t1 order by 1,2,3,4;
truncate table t1;



-- columns with HV
insert into t1 values ('4',n'4',2);

prepare st from 'select mod (? , i2) from t1';
execute st using '4';

prepare st from 'select mod (? , i2) from t1';
execute st using NULL;

prepare st from 'select mod (i2 , ?) from t1';
execute st using n'1';

prepare st from 'select mod (s1 , ?) from t1';
execute st using 0.2e1;

prepare st from 'select mod (? , sn1) from t1';
execute st using 9.0;

prepare st from 'select mod (s1 , ?) from t1';
execute st using NULL;

prepare st from 'select mod (s1 , ?) from t1';
execute st using 0;

drop table t1;

-- constants
select mod ('2001-10-11' , 4);

select mod (4, '2');

select mod (4 , 'abc');

select mod (4 , NULL);


-- 2 HV
prepare st from 'select mod (? , ?)';
execute st using '2001-10-11',4;

prepare st from 'select mod (? , ?)';
execute st using 4,'abc';

prepare st from 'select mod (? , ?)';
execute st using 4,'2';

prepare st from 'select mod (? , ?)';
execute st using 4,NULL;

prepare st from 'select mod (? , ?)';
execute st using 4,2;

prepare st from 'select mod (? , ?)';
execute st using 4.0,2;


-- 1 HV
prepare st from 'select mod (4 , ?)';
execute st using '2';

prepare st from 'select mod (4 , ?)';
execute st using 2.0;

prepare st from 'select mod (? , ''2'')';
execute st using 4;



