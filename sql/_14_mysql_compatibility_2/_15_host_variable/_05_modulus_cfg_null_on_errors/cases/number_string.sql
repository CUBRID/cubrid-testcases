--+ holdcas on;
-- MOD (number , string)

set system parameters 'return_null_on_function_errors=yes';

create table t1 (s1 varchar(10),sn1 nchar varying(10), i2 int);

insert into t1 values ('4',n'4',2);
insert into t1 values (NULL,n'4',2);
insert into t1 values ('4',n'2',NULL);
insert into t1 values ('4a',n'2',2);
insert into t1 values ('4',n'2a',2);
select s1,sn1,i2, mod(s1,i2) from t1 order by 1,2,3,4;
select s1,sn1,i2, mod(i2,sn1) from t1 order by 1,2,3,4;
select s1,sn1,i2, mod(s1,sn1) from t1 order by 1,2,3,4;

drop table t1;

-- constants
select mod ('2001-10-11' , 4);

select mod (4 , 'abc');

select mod (4 , NULL);


-- 2 HV
prepare st from 'select mod (? , ?)';
execute st using '2001-10-11',4;
deallocate prepare st;

prepare st from 'select mod (? , ?)';
execute st using 4,'abc';
deallocate prepare st;

prepare st from 'select mod (? , ?)';
execute st using 4,NULL;
deallocate prepare st;


set system parameters 'return_null_on_function_errors=no';
commit;
--+ holdcas off;
