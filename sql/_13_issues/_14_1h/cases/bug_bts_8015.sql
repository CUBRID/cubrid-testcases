drop if exists t1;

create table t1(a date , b date);
select default(a), default(b) from t1 x, t1 y;

select default(db_root) from db_root;

drop if exists t1;
set @t1_default = date('2014-01-06');
create table t1(t1 date default @t1_default, b date);
insert into t1 values('2014-01-01', '2014-01-01');
select date(t1) from t1;
select date( default(t1)) from t1;

drop if exists t1;
