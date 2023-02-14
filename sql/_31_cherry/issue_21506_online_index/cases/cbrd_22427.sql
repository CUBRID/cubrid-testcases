drop table if exists t;
create table t(t timestamp, i int) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));

insert into t values('1970-3-10', 1);

insert into t values('1970-3-10', 1);

create unique index ui2 on t(i, t) with online;

show index from t;

delete from t where i=1 limit 1;

insert into t values('1970-3-10', 2);

create unique index ui2 on t(i, t) with online;

update statistics on t;
show index from t;

select * from t ignore index (ui2) where i > 0 order by 1,2;

select * from t force index (ui2) where i > 0 order by 1,2;

drop t;
