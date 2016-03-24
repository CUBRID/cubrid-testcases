--test null with greast
create class t1(c1 int, c2 varchar(20));
insert into t1 values(101, 'aaa');
insert into t1 values(null, 'aaa');
insert into t1 values(null, 'aaa');
insert into t1 values(null, 'aaa');


select greatest(c1) from t1;
select least(c1) from t1;

drop class t1;