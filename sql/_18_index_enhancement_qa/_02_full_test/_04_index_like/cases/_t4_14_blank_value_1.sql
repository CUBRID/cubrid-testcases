create table t (a varchar(10));

insert into t values ('');
insert into t values (' ');
insert into t values ('  ');

--result is good
select concat('[',a,']') from t where a like '%' order by 1 desc;
--result is not correct
select concat('[',a,']') from t where a like '' order by 1 desc;
--result is not correct
select concat('[',a,']') from t where a like ' ' order by 1 desc;

drop table t;

