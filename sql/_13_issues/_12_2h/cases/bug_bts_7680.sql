Create table t (col1 char(100));
create index idx on t(col1(2));
insert into t values('가伽佳假價加可呵哥嘉');
insert into t values('zvbasdasd');
insert into t values('abcdefghig');
select/*+ recompile*/count(*) from t where col1>'abc' using index none  ;
select/*+ recompile*/count(*)  from t where col1>'abc' ;
drop table t;

autocommit off;
set names utf8;
Create table t (col1 char(10) charset utf8);
create index idx on t(col1(2));
insert into t values('가伽佳假價加可呵哥嘉');
insert into t values('zvbasdasd');
insert into t values('abcdefghig');
select/*+ recompile*/count(*) from t where col1>'abc' using index none ;
select/*+ recompile*/count(*) from t where col1>'abc' ;
drop table t;
set names iso88591;
rollback;
autocommit on;

