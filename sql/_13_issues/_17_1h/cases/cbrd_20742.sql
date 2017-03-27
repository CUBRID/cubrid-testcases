--+ holdcas on;

drop table if exists t1;

create table t1(s1 string,s2 varchar);

create index idx_t1 on t1(s1,s2);

insert into t1 values('abc',repeat('a',1000));

insert into t1 values(repeat('b',1000),'abc'); 

insert into t1 values(repeat('b',1000),repeat('abc',300));

select s1,s2 from t1 where s1>0 start with s1>0 and s2 is not null connect by prior s1=s2 order by s1;


drop table if exists t2;

create table t2(s1 string,s2 varchar);

create index idx_t2 on t2(s1,s2);

insert into t2 values('abc',repeat('a',1000));

insert into t2 values(repeat('b',1000),'abc'); 

insert into t2 values(repeat('b',1000),repeat('abc',300));

select t1.s1,t2.s2,level from t1 inner join t2 on t1.s1=t2.s1 start with t1.s2 is not null connect by prior t1.s1=t1.s2 order by t1.s1 limit 1;


drop index idx_t1 on t1;

create index idx_t1 on t1(s2);

select s1,s2 from t1 start with s2>'a' connect by prior s1=s2 order by s1; 


drop table t1;

drop table t2;

--+ holdcas off;