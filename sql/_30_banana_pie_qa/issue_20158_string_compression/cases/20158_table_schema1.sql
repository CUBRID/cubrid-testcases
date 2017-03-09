--+ holdcas on;

drop table if exists t;

drop table if exists t1;

drop table if exists t2;

create table t(i1 int,s1 string,s2 char(500));

insert into t values(1,'a','b');

insert into t values(2,repeat('a',200),repeat('a',200));

insert into t values(3,repeat('a',500),repeat('a',500));

select * from t t1,t t2 where t1.s1=t2.s1 order by t1.i1;

select * from t t1,t t2 where t1.s1=t2.s2 order by t1.i1;

create index idx_t1 on t(s1);

select * from t t1,t t2 where t1.s1=t2.s2 using index t1.idx_t1 order by t1.s1;

drop index idx_t1 on t;

create index idx_t1 on t(s1,s2);

--- group by having
select * from t t1,t t2 where t1.s1=t2.s1 group by t1.s1 having t1.s1>'a' order by t2.s1 desc;

--- create ... select
create table t1 as select * from t;

select i1,disk_size(s1),disk_size(s2) from t1 order by i1;

--- create ... like
create table t2 like t;

insert into t2 values(1,'a','b');

insert into t2 values(2,repeat('a',200),repeat('a',200));

insert into t2 values(3,repeat('a',500),repeat('a',500));

select i1,disk_size(s1),disk_size(s2) from t2 order by i1;

select distinct t.s1,t1.i1,t2.s2 from t,t1,t2 order by t1.i1,t2.s2 limit 1;

select * from t,t1,t2 where t.s1=t1.s1 and t1.s1=t2.s2 group by t.s1,t1.s2 order by t.i1 desc;

--- join
select * from t inner join t1 on t1.s1=t.s1 order by t1.s1 desc limit 1;

select * from t left join t2 on t2.s1=t.s1 where t2.s1>'aa' group by t.s1 having t.s2>'a' order by 1;

select * from t right join t2 on t2.s1=t.s1 where t2.s1>'aa' group by t.s1 having disk_size(t.s1)>200;

select count(*),(select t1.s1 from t t1,t t2 where t1.s1=t2.s1 order by t1.s1 limit 1) as t_s1 from t1;

--- connect by
select t.s1,t.s2 from t connect by prior t.s1=t.s2 order by t.i1 desc limit 1;

--- value/for update
select t1.i1,t2.s1,disk_size(t2.s1) from t t1,(values(repeat('a',500),repeat('a',500))) as t2(s1,s2) where t1.s1=t2.s1 and t1.s2=t2.s2; 

SELECT i1,s1,s2,disk_size(s1),disk_size(s2) FROM t1 ORDER BY s1 FOR UPDATE OF t1; 
  
--- like/in
select * from t where s1 like 'a%' and s1 in (repeat('a',500));

--- between
select * from t where s1 between 'aaa' and repeat('a',499);

--- exists
select count(*) from t where exists(select * from t1 where s1<'b');

--- any
select count(*) from t where s1=any{repeat('a',500)};

drop table t;

drop table t2;

drop table t1;

--+ holdcas off;