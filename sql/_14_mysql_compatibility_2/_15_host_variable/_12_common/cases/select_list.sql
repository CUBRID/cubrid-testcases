create table t1 (i1 int);
insert into t1 values(3);
insert into t1 values(30);

prepare st from 'select 1 + (select max(i1 + ? ) from t1) from t1';
execute st using 10;
deallocate prepare st;

prepare st from 'select 1 + (select sum(i1 + ? ) from t1) from t1';
execute st using 10;
deallocate prepare st;

prepare st from 'select 2.2,max(i1 + ? )  from t1';
execute st using 10;
deallocate prepare st;

prepare st from 'select count(i1),3,max(i1 + ? ) , sum (? / i1) from t1';
execute st using 10,20;
deallocate prepare st;

drop table t1;



-- first values NULL
create table t1 (i1 int);
insert into t1 values(NULL);
insert into t1 values(3);
insert into t1 values(NULL);

prepare st from 'select 1 + (select max(i1 + ? ) from t1) from t1';
execute st using 10;
deallocate prepare st;

prepare st from 'select count(i1),3,max(i1 + ? ) , sum (? / i1) from t1';
execute st using 10,20;
deallocate prepare st;

drop table t1;


-- all values NULL
create table t1 (i1 int);
insert into t1 values(NULL);
insert into t1 values(NULL);
insert into t1 values(NULL);

prepare st from 'select 1 + (select max(i1 + ? ) from t1) from t1';
execute st using 10;
deallocate prepare st;

prepare st from 'select count(i1),3,max(i1 + ? ) , sum (? / i1) from t1';
execute st using 10,20;
deallocate prepare st;

drop table t1;

