--test null with Arithmetic operators 
create class t1(c1 int, c2 varchar(20));
insert into t1 values(101, 'aaa');
insert into t1 values(null, 'aaa');
insert into t1 values(null, 'aaa');
insert into t1 values(null, 'aaa');

select c1+100, c1-100, c1*100, c1/100 from t1 order by 1 desc,2,3,4;

drop class t1;
