autocommit off;
create table t (a int);
create table t2 (b t);
create view v as select * from t ;
create view v2 (b v) as select * from t2 where b.a > 10 with check option;
insert into v2 values (insert into v values (4));
select * from t;
select * from t2;
rollback;
