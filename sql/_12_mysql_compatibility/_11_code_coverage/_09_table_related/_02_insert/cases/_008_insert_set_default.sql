-- INSERT  ... ON DUPLICATE KEY UDPATE 

create table t1 (i1 integer default 0);

insert into t1 set i1=default;

select * from t1;

drop table t1;

