drop table if exists t1;
create table t1 (i1 int,d1 double,f1 float);
insert into t1 values(1,1.2,1);
insert into t1 values(2,2.5,2);
insert into t1 values(2,2.5,2);
insert into t1 values(10,1.2e2,4);
insert into t1 values(20,2.5e2,5);

select * from t1 order by 1,2,3;

select i1+3,d1 from t1 group by i1+3;

prepare st from 'select i1+?,d1 from t1 group by i1+?';
execute st using 3,3;
deallocate prepare st;


select i1,d1 from t1 group by i1+3.3;

prepare st from 'select i1,d1 from t1 group by i1+?';
execute st using 3.3;
deallocate prepare st;



select f1+3.3,d1 from t1 group by i1+3.3;

prepare st from 'select f1+?,d1 from t1 group by i1+?';
execute st using 3.3,3.3;
deallocate prepare st;


select f1+3.3,d1,d1+6 from t1 group by i1+3.3;

prepare st from 'select f1+?,d1,d1+? from t1 group by i1+?';
execute st using 3.3,6,3.3;
deallocate prepare st;


select f1+3.3,d1 from t1 group by i1;

prepare st from 'select f1+?,d1 from t1 group by i1';
execute st using 3.3;
deallocate prepare st;


select i1+3,d1 from t1 group by 1;
-- should fail:   cannot be a GROUP by column
prepare st from 'select i1+3,d1 from t1 group by ?';
execute st using 1;
deallocate prepare st;

select f1+3.3,d1 from t1 group by i1 having f1<3;

prepare st from 'select f1+?,d1 from t1 group by i1 having f1<?';
execute st using 3.3,3;
deallocate prepare st;

prepare st from 'select count(i1) from t1 group by 1+?';
execute st using 1.1;
deallocate prepare st;

prepare st from 'select i1 from t1 group by d1+?';
execute st using 1.1;
deallocate prepare st;

drop table t1;


-- first rows NULL
create table t1 (i1 int,d1 double,f1 float);
insert into t1 values(NULL,NULL,5.2);
insert into t1 values(1,1.2,1);
insert into t1 values(2,2.5,2);
insert into t1 values(2,2.5,2);
insert into t1 values(10,1.2e2,4);
insert into t1 values(20,2.5e2,5);
insert into t1 values(NULL,NULL,5.2);

select i1+3,d1 from t1 group by i1+3;

prepare st from 'select i1+?,d1 from t1 group by i1+?';
execute st using 3,3;
deallocate prepare st;


select f1+3.3,d1,d1+6 from t1 group by i1+3.3;

prepare st from 'select f1+?,d1,d1+? from t1 group by i1+?';
execute st using 3.3,6,3.3;
deallocate prepare st;


select 4.2+f1,max(i1+2) from t1 group by d1;

prepare st from 'select 4.2+f1,max(i1+?) from t1 group by d1';
execute st using 2;
deallocate prepare st;

drop table t1;



-- first rows NULL -- 2
create table t1 (i1 int,d1 double,f1 float);
insert into t1 values(NULL,1.0,2);
insert into t1 values(NULL,1.0,2);
insert into t1 values(2,2.0,3);
insert into t1 values(3,4.0,10);
insert into t1 values(NULL,1.0,2);

select min(f1-1),group_concat(i1+2 order by 1),d1 from t1 group by d1;

prepare st from 'select min(f1-?),group_concat(i1+? order by 1),d1 from t1 group by d1';
execute st using 1,2;
deallocate prepare st;

drop table t1;


-- all rows NULL
create table t1 (i1 int,d1 double,f1 float);
insert into t1 values(NULL,NULL, NULL);
insert into t1 values(NULL,NULL, NULL);
insert into t1 values(NULL,NULL, NULL);
insert into t1 values(NULL,NULL, NULL);

select i1+3,d1 from t1 group by i1+3;

prepare st from 'select i1+?,d1 from t1 group by i1+?';
execute st using 3,3;
deallocate prepare st;


select f1+3.3,d1,d1+6 from t1 group by i1+3.3;

prepare st from 'select f1+?,d1,d1+? from t1 group by i1+?';
execute st using 3.3,6,3.3;
deallocate prepare st;


select 4.2+f1,max(i1+2) from t1 group by d1;

prepare st from 'select 4.2+f1,max(i1+?) from t1 group by d1';
execute st using 2;
deallocate prepare st;

drop table t1;
