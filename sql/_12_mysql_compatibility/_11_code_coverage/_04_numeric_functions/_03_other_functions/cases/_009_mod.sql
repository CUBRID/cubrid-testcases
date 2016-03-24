create table t1(i1 integer, sh short, b bigint, d double, n numeric(10,2), s char varying);
insert into t1 values (1,2,3,4,5,'1234');
insert into t1 values (NULL,2,3,4,5,'1234');
insert into t1 values (1,NULL,3,4,5,'1234');
insert into t1 values (1,2,NULL,4,5,'1234');
insert into t1 values (1,2,3,NULL,5,'1234');
insert into t1 values (1,2,3,4,NULL,'1234');
insert into t1 values (1,2,3,4,5,NULL);

select i1 % 1 from t1 order by i1,sh,b,d,n,s;

select 1 % i1 from t1 order by i1,sh,b,d,n,s;

select i1 % i1 from t1 order by i1,sh,b,d,n,s;
select sh % sh from t1 order by i1,sh,b,d,n,s;
select b % b from t1 order by i1,sh,b,d,n,s;
-- should fail
select d % d from t1 order by d;
-- should fail
select n % n from t1 order by n;
-- should fail
select s % s from t1 order by s;

select 1 % 2;

drop table t1;
