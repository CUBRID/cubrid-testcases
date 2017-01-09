--+ holdcas on;
drop table if exists t;
drop table if exists s;

create table t( i int, a varchar) PARTITION BY RANGE (a) (PARTITION before_d VALUES LESS THAN ('d'),PARTITION before_e VALUES LESS THAN ('m'));

create table s( i int, a string) PARTITION BY RANGE (a) (PARTITION before_d VALUES LESS THAN ('d'),PARTITION before_e VALUES LESS THAN ('m'));

create index i_t_a  on t(a);

create index i_s_a  on s(a);

insert into t values(1,repeat('a',300));

insert into t values(1,repeat('f',300));

insert into s values(1,repeat('a',300));

insert into s values(1,repeat('f',300));

insert into s values(1,repeat('b',300));

select t.a,s.a from t,s where t.a=s.a and t.a>'e' order by t.a;

select t.a,s.a from t RIGHT OUTER JOIN s on t.a=s.a where t.a>'e' order by t.a;  

select t.a,s.a from t left OUTER JOIN s on t.a=s.a where t.a>'e' order by t.a;

select * from s__p__before_d s,t__p__before_d t where s.a > t.a group by s.a having s.a>'b' using index s.i_s_a order by t.a desc limit 1;

drop table t;

drop table s;

--+ holdcas off;