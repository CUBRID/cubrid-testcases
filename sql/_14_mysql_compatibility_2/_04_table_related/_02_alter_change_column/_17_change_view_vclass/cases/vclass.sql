---- ALTER VCLASS ...  CHANGE COLUMN  
-- changing view's attribute with ALTER VCLASS .. CHANGE is not allowed
-- although allowed at grammar level (due to common rules), it is forbidden at semantic check level

create class t1 (i1 integer, i2 integer);
create vclass v1 as select i1*2 as i1, i2/2 as i2 from t1;

insert into t1 set i2=1;

select * from t1;
select * from v1;

desc t1;
desc v1;


-- all should fail
alter vclass v1 change i2 i2 int;

alter vclass v1 change i2 i2 int default 4;

alter vclass v1 modify i2 int;

alter vclass v1 modify i2 int not null;



insert into t1 set i2=2;

select * from t1 order by 1,2;
select * from v1 order by 1,2;

desc t1;
desc v1;


drop vclass v1;
drop class t1;


