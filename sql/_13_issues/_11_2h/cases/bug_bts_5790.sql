create table t1_ns(a int, b int);

create table t2_ns like t1_ns;

select count(*) from t1_ns left outer join t2_ns on t1_ns.a=t2_ns.a and t1_ns.b=t2_ns.b where 1=1;

insert into t1_ns values(1,2);
insert into t1_ns values(null,3);
insert into t1_ns values(5,6);

insert into t2_ns values(1,2);
insert into t2_ns values(4,3);
insert into t2_ns values(7,8);

select t1_ns.*,t2_ns.* from t1_ns left outer join t2_ns on t1_ns.a=t2_ns.a and t1_ns.b=t2_ns.b where 1=1;

drop table t1_ns,t2_ns;
 
