create table t1(i1 integer, b bigint, sh short, f float, d double,d1 date,n numeric(10,2));

insert into t1 values (1, 1230, 1, 1.2, 1.3,date'2010-10-10',2);

-- should fail
select if(i1,i1,b) from t1;

select if(1<2,d1,b) from t1;

select if(1<2,b,d1) from t1;

select if(1<2,NULL,NULL) from t1;

select if(1<2,d,d) from t1;

select if(1<2,f,f) from t1;

select if(1<2,n,n) from t1;

select if(1<2,b,b) from t1;

select if(1<2,sh,sh) from t1;


select if(1<2,i1,sh) from t1;

select if(1<2,n,sh) from t1;

select if(1<2,b,i1) from t1;

drop table t1;
