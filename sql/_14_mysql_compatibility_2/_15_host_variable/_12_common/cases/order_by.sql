drop table if exists t1;
create table t1 (i1 int,d1 double);
insert into t1 values(1,1.2);
insert into t1 values(2,2.5);
insert into t1 values(10,1.2e1);
insert into t1 values(20,2.5e1);

select * from t1 order by 1,2;

select i1+3 from t1 order by 1;

prepare st from 'select i1+? from t1 order by 1';
execute st using 3;
deallocate prepare st;


select i1+3.2 from t1 order by 1;

prepare st from 'select i1+? from t1 order by 1';
execute st using 3.2;
deallocate prepare st;


prepare st from 'select ? - d1 from t1 order by 1';
execute st using 3;
deallocate prepare st;

prepare st from 'select ? - d1 from t1 order by 1';
execute st using 3.0;
deallocate prepare st;

prepare st from 'select ? - d1 from t1 order by ?';
execute st using 3.0,1;
deallocate prepare st;

select i1,d1 from t1 order by i1 + 3.3;

prepare st from 'select i1,d1 from t1 order by i1 + ?';
execute st using 3.3;
deallocate prepare st;

drop table t1;



-- first values NULL
create table t1 (i1 int,d1 double);
insert into t1 values(NULL,NULL);
insert into t1 values(1,1.2);
insert into t1 values(2,2.5);
insert into t1 values(10,1.2e1);
insert into t1 values(20,2.5e1);
insert into t1 values(NULL,NULL);

select * from t1 order by 1,2;

select i1+3.2 from t1 order by 1;

prepare st from 'select i1+? from t1 order by 1';
execute st using 3.2;
deallocate prepare st;


prepare st from 'select ? - d1 from t1 order by 1';
execute st using 3.0;
deallocate prepare st;

select i1,d1 from t1 order by i1 + 3.3;

prepare st from 'select i1,d1 from t1 order by i1 + ?';
execute st using 3.3;
deallocate prepare st;

drop table t1;



-- all values NULL
create table t1 (i1 int,d1 double);
insert into t1 values(NULL,NULL);
insert into t1 values(NULL,NULL);
insert into t1 values(NULL,NULL);

select * from t1 order by 1,2;

select i1+3.2 from t1 order by 1;

prepare st from 'select i1+? from t1 order by 1';
execute st using 3.2;
deallocate prepare st;


prepare st from 'select ? - d1 from t1 order by 1';
execute st using 3.0;
deallocate prepare st;

select i1,d1 from t1 order by i1 + 3.3;

prepare st from 'select i1,d1 from t1 order by i1 + ?';
execute st using 3.3;
deallocate prepare st;

drop table t1;
