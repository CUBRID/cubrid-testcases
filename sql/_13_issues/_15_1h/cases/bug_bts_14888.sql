
drop table if exists t;

create table t(t timestamp, i int) partition by list(t) (
partition p0 values in ('1970-3-10'),
partition p1 values in ('1971-2-01'),
partition p2 values in ('1972-2-19'));

insert into t values('1970-3-10', 1);
insert into t values('1970-3-10', 1);

--expected error
create unique index ui on t(i, t);
create reverse index ri1 on t(last_day(t));

drop table t;

