--- MOD (number , number )


create table t1 (d1 double, i1 int, n1 numeric(10,3));

insert into t1 values (9,5,2);
--- table columns
select mod (d1,i1) from t1;
select mod (d1,n1) from t1;
select mod (i1,n1) from t1;

--prepared statements
-- double column 
prepare st from 'select mod (? , d1) from t1';
execute st using 10;
deallocate prepare st;

prepare st from 'select mod (d1 , ?) from t1';
execute st using 2;
deallocate prepare st;

prepare st from 'select mod (? , d1) from t1';
execute st using 10.0e0;
deallocate prepare st;

prepare st from 'select mod (d1 , ?) from t1';
execute st using 2.0e0;
deallocate prepare st;

-- int column 
prepare st from 'select mod (i1 , ?) from t1';
execute st using 1;
deallocate prepare st;

prepare st from 'select mod (? , i1) from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select mod (i1 , ?) from t1';
execute st using 0.1e1;
deallocate prepare st;

prepare st from 'select mod (? , i1) from t1';
execute st using 0.4e1;
deallocate prepare st;

-- numeric
prepare st from 'select mod (n1 , ?) from t1';
execute st using 1;
deallocate prepare st;

prepare st from 'select mod (? , n1) from t1';
execute st using 4;
deallocate prepare st;

prepare st from 'select mod (n1 , ?) from t1';
execute st using 1.0;
deallocate prepare st;

prepare st from 'select mod (? , n1) from t1';
execute st using 0.4e1;
deallocate prepare st;


drop table t1;


select mod (4 , 2.0);

select mod (4 , 2);

select mod (4 , 0.2e1);


prepare st from 'select mod (4 , ?)';
execute st using 2;
deallocate prepare st;

prepare st from 'select mod (? , 0.2e1)';
execute st using 4;
deallocate prepare st;


prepare st from 'select mod ( ? , ? )';
execute st using 4,2;
deallocate prepare st;

prepare st from 'select mod (? , ?)';
execute st using 4,2.0;
deallocate prepare st;

