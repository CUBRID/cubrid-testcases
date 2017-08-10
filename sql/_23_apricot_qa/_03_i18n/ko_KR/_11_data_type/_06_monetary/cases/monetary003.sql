create table t(a monetary);
insert into t values(to_number('123,456,789','999,999,999'));
insert into t values(to_number('-123,456,789'));
insert into t values(to_number('123.456.789'));
insert into t values(to_number('-123.456.789'));
insert into t values(to_number('1.234,56','999.999,999'));
insert into t values(to_number('-1.234,56'));
select * from t order by 1;
drop table t;
