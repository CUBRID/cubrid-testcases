---- ALTER VIEW ...  CHANGE COLUMN  
-- changing view's attribute with ALTER VIEW .. CHANGE is not allowed
-- although allowed at grammar level (due to common rules), it is forbidden at semantic check level

create table t1 (i1 integer, i2 integer);
create view v1 as select i1*2 as i1, i2/2 as i2 from t1;

insert into t1 set i2=1;

select * from t1;
select * from v1;

desc t1;
desc v1;


-- all should fail
alter view v1 change i2 i2 int;

alter view v1 change i2 i2 int default 4;

alter view v1 modify i2 int;

alter view v1 modify i2 int not null;



insert into t1 set i2=2;

select * from t1;
select * from v1;

desc t1;
desc v1;


drop view v1;
drop table t1;


