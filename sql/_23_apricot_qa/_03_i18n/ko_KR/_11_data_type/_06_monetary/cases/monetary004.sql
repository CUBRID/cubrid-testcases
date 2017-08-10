create table t(a monetary default \CNY 3,b monetary );
insert into t(a,b) values(₩123,-5.1);
insert into t(b) values(5.1);
select * from t order by 1;
drop table t;
