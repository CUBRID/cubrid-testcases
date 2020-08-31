drop table if exists t,s;
create table t(a int ,name varchar(4));
create table s(a int  ,score double);
insert into t values(1,'bert');
insert into t values(2,'cole');
insert into t values(3,'bill');
insert into t values(4,'dick');
insert into t values(null,null);
insert into s values(1,'99');
insert into s values(2,'88.5');
insert into s values(3,'66');
insert into s values(4,'95');

select case when v2.a is null then v1.a else v2.a end a from ( select a from t) v1 left outer join ( select a from t) v2 on v1.a = v2.a order by 1;
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from t) v1 left outer join ( select a from t) v2 on v1.a = v2.a) xx where xx.a = 2 order by 1;
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from t) v1 left outer join ( select a from t) v2 on v1.a = v2.a) xx where xx.a is not null order by 1;

 
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from t) v1 left outer join ( select a from s) v2 on v1.a = v2.a) xx where xx.a = 3 order by 1;
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from t) v1 left outer join ( select a from s) v2 on v1.a = v2.a) xx where xx.a is not null order by 1;
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from t) v1 left outer join ( select a from s) v2 on v1.a = v2.a) xx where xx.a is null order by 1;


select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from s) v2 left outer join ( select a from t) v1 on v2.a = v1.a) xx where xx.a is not null order by 1;
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from s) v2 left outer join ( select a from t) v1 on v2.a = v1.a) xx where xx.a=3 order by 1;
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from s) v2 left outer join ( select a from t) v1 on v2.a = v1.a) xx where xx.a is null order by 1;

select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from s) v1 right outer join ( select a from t) v2 on v1.a = v2.a) xx where xx.a is not null order by 1;
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from s) v2 right outer join ( select a from t) v1 on v2.a = v1.a) xx where xx.a=3 order by 1;
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from s) v2 right outer join ( select a from t) v1 on v2.a = v1.a) xx where xx.a is null order by 1; 

insert into s values(null,null);
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from t) v1 left outer join ( select a from s) v2 on v1.a = v2.a) xx where xx.a = 3 order by 1;
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from t) v1 left outer join ( select a from s) v2 on v1.a = v2.a) xx where xx.a is not null order by 1;

drop s,t;
