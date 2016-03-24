create table t1 (id int primary key, cname varchar(32));

insert into t1 values(1, 'Divid');
insert into t1 values(2, 'Frank');
select row_count() from t1;
select 1;
select row_count() from t1;
drop table t1;