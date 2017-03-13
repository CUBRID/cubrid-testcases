--+ holdcas on;

drop table if exists t;

create table t (i1 varchar, i2 varchar);

create index i_t_123 on t(i1, i2);

insert into t values ('a', repeat('a',300));
insert into t values ('b', repeat('a',300));
insert into t values ('c', repeat('a',300));
insert into t values ('a', repeat('a',300));
insert into t values ('b', repeat('a',300));
insert into t values ('c', repeat('a',300));
insert into t values ('a', repeat('a',300));
insert into t values ('b', repeat('a',300));
insert into t values ('c', repeat('a',300));
insert into t values ('a', repeat('a',300));
insert into t values ('b', repeat('a',300));
insert into t values ('c', repeat('a',300));

select max(i2) from (select i1,i2 from t where i2>'a' and i1>'a' union all select i1,i2 from t where i1>'a' and i2>'a');

select * from t t1 where i1 >(select max(i2) from (select i1+i2 from t where i1=t1.i1 and i1<'c'));

select i1+'1',row_number() over(partition by i2 order by i2)from t where i1<'d';

select /*+ recompile */* from t where i1 between 'a' and 'd' and i2 between 'a' and 'c' order by 1 limit 1;

--test: aggreage function in subquery of where clause
select /*+ recompile */i1 from t where exists(select /*+ recompile */* from t where i2>'a' and i1>'b') and i2<'c' and i1>'b';

select * from t where i1>'b' group by i2 having max(i2) > 'a';

insert into t values(null,null);

SELECT * FROM t ORDER BY i2 NULLS FIRST,i1 desc limit 2;

select i1,list(select i2 from t where i1>'b') as aa from t order by i1 desc,i2 limit 1;

select * from t group by disk_size(i2);

select i1,ifnull(i2,'test') from t group by i1 order by 1,2;

--test: aggreage function in subquery of update statement
update t set i1=(select i2 from t where i2>'a' and i1>'b' order by 1 limit 1) where i1='c';

select * from t where disk_size(i1) > 20;

drop t;

--+ holdcas off;