--+ holdcas on;
-- host variable 

create table t1 ( i1 integer , i2 integer );
insert into t1 values (1,1),(1,2),(2,3),(2,2),(2,5),(3,5);
select * from t1 order by 1,2;

prepare st from 'select i1+? from t1 order by 1';
execute st using 2;

-- should fail
prepare st from 'select i1+? from t1 order by 1';
execute st using ?;

prepare st from 'select i1 from t1 limit ? order by 1';
execute st using 2;

drop table t1;


select ?:1 from db_root order by 1;

-- should fail  - HOST VAR not allowed here
prepare st from 'select ? from t1 limit ? order by 1';
execute st using ?:1;


set system parameters 'compat_mode=mysql';
-- should fail
prepare st from 'prepare aa from "select 1"';
execute st;

set system parameters 'compat_mode=cubrid';

-- should fail - statement not found
execute not_valid_statement;

-- should fail - statement not found
drop prepare not_valid_statement;

-- should fail - incorrect number of values 
prepare st from 'select concat(?,?)';
execute st using 'a','b','c';

-- should fail - incorrect number of values
prepare st from 'select concat(?,?)';
execute st;
commit;
--+ holdcas off;
