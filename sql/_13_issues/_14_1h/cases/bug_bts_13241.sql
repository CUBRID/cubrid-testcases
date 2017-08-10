create table t(a datetime);
insert into t values('2012-05-05 10:10:10 AM');

select a from t;
select a, trunc(a, 'day') from t;

drop table if exists t;
