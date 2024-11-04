drop table if exists t1;
create table t1 (i1 int,i2 int);
insert into t1 values(3,-1);
insert into t1 values(30,-1);
insert into t1 values(30,-1);
insert into t1 values(2,-1);
insert into t1 values(1,-1);
insert into t1 values(2,-1);

select * from t1 order by 1,2;

prepare st from 'update t1 set i2=10 where i1=i2 + ?';
execute st using 2;
deallocate prepare st;

truncate t1;
insert into t1 values(3,-1);
insert into t1 values(30,-1);
insert into t1 values(30,-1);
insert into t1 values(2,-1);
insert into t1 values(1,-1);
insert into t1 values(2,-1);

prepare st from 'update t1 set i2=0 where i1=?';
execute st using 3;
deallocate prepare st;

update t1 set i2=0 where i1=(select max(i1+2.2) from t1);

select * from t1 order by 1,2;
truncate t1;
insert into t1 values(3,-1);
insert into t1 values(30,-1);
insert into t1 values(30,-1);
insert into t1 values(2,-1);
insert into t1 values(1,-1);
insert into t1 values(2,-1);

prepare st from 'update t1 set i2=1 where i1=(select max(i1 + ? ) from t1)';
execute st using 0.0;
deallocate prepare st;

prepare st from 'update t1 set i2=2 where i1+?=(select max(i1 + ? ) from t1)';
execute st using 0,0;
deallocate prepare st;

-- hidden columns in SELECT list : UPDATE
prepare st from 'update t1 set i2=3 order by (? + i1) limit 3';
execute st using 3.2;
deallocate prepare st;

select * from t1 order by 1,2;

drop table t1;


-- first values NULL
create table t1 (i1 int,i2 int);
insert into t1 values(NULL,-1);
insert into t1 values(3,-1);
insert into t1 values(30,-1);
insert into t1 values(30,-1);
insert into t1 values(2,-1);
insert into t1 values(1,-1);
insert into t1 values(2,-1);
insert into t1 values(NULL,-1);

select * from t1 order by 1,2;

prepare st from 'update t1 set i2=10 where i1=i2 + ?';
execute st using 2;
deallocate prepare st;

truncate t1;
insert into t1 values(3,-1);
insert into t1 values(30,-1);
insert into t1 values(30,-1);
insert into t1 values(2,-1);
insert into t1 values(1,-1);
insert into t1 values(2,-1);

prepare st from 'update t1 set i2=0 where i1=?';
execute st using 3;
deallocate prepare st;


select * from t1 order by 1,2;
truncate t1;
insert into t1 values(3,-1);
insert into t1 values(30,-1);
insert into t1 values(30,-1);
insert into t1 values(2,-1);
insert into t1 values(1,-1);
insert into t1 values(2,-1);

prepare st from 'update t1 set i2=1 where i1=(select max(i1 + ? ) from t1)';
execute st using 0.0;
deallocate prepare st;


-- hidden columns in SELECT list : UPDATE
prepare st from 'update t1 set i2=3 order by (? + i1) limit 3';
execute st using 3.2;
deallocate prepare st;

select * from t1 order by 1,2;

drop table t1;



-- all values NULL
create table t1 (i1 int,i2 int);
insert into t1 values(NULL,-1);
insert into t1 values(NULL,-1);
insert into t1 values(NULL,-1);
insert into t1 values(NULL,-1);

select * from t1 order by 1,2;

prepare st from 'update t1 set i2=10 where i1=i2 + ?';
execute st using 2;
deallocate prepare st;

prepare st from 'update t1 set i2=0 where i1=?';
execute st using 3;
deallocate prepare st;

prepare st from 'update t1 set i2=1 where i1=(select max(i1 + ? ) from t1)';
execute st using 0.0;
deallocate prepare st;

-- hidden columns in SELECT list : UPDATE
prepare st from 'update t1 set i2=3 order by (? + i1) limit 3';
execute st using 3.2;
deallocate prepare st;

select * from t1 order by 1,2;

drop table t1;
