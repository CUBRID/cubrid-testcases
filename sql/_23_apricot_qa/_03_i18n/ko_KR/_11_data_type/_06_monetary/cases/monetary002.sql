create table t(a monetary);
insert into t values(123,456,789);
insert into t values(-123,456,789);
insert into t values(123.456.789);
insert into t values(-123.456.789);
insert into t values(1.234,56);
insert into t values(-1.234,56);
select * from t order by 1;
drop table t;
