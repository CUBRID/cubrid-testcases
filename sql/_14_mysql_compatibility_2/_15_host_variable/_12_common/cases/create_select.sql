
create table t1 (i1 int,i2 int);
insert into t1 values(3,-1);
insert into t1 values(30,-1);

select * from t1 order by 1,2;

-- PLUS , INT + INT
prepare st from 'create table t2 as select i1+? as i_1 from t1';
execute st using 3;
deallocate prepare st;

desc t2;
select * from t2 order by 1;
drop table t2;

-- PLUS , INT + DOUBLE
prepare st from 'create table t2 as select i1+? as i_1 from t1';
execute st using 3.0e0;
deallocate prepare st;

desc t2;
select * from t2 order by 1;
drop table t2;

-- MINUS , DATE - INT
prepare st from 'create table t2 as select ? - i1 as i_1 from t1';
execute st using date'2001-10-11';
deallocate prepare st;

desc t2;
select * from t2 order by 1;
drop table t2;

-- ABS (string)
prepare st from 'create table t2 as select abs(?) as a from t1';
execute st using '2.2';
deallocate prepare st;

desc t2;
select * from t2 order by 1;
drop table t2;

-- TRUNC (numeric, int)
prepare st from 'create table t2 as select trunc(?,i1) as tr from t1';
execute st using 2.123456;
deallocate prepare st;

desc t2;
select * from t2 order by 1;
drop table t2;

drop table t1;
