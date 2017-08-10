create table t (a varchar(10));

insert into t values ('');
insert into t values (' ');
insert into t values ('  ');

--result is good
select concat('[',a,']') from t where a like '%';
--result is not correct
select concat('[',a,']') from t where a like '';
--result is not correct
select concat('[',a,']') from t where a like ' ';

drop table t;

