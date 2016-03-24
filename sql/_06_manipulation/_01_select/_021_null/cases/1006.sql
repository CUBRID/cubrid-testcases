--test null with min(), max() function
create class t1(c1 int, c2 varchar(20));
insert into t1 values(101, 'aaa');
insert into t1 values(null, 'aaa');
insert into t1 values(null, 'aaa');
insert into t1 values(null, 'aaa');

select max(c1) from t1;
select min(c1) from t1;

drop class t1;