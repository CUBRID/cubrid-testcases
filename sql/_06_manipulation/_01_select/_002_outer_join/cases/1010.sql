--test left outer join using a select statement and the 'case when' keyword

create class t ( a int ); 
insert into t values(10); 
insert into t values(20); 
insert into t values(30); 
insert into t values(null);
select xx.a from ( select case when v2.a is null then v1.a else v2.a end a from ( select a from t) v1 left outer join ( select a from t) v2 on v1.a = v2.a) xx where  xx.a is null order by 1;


drop table t;
