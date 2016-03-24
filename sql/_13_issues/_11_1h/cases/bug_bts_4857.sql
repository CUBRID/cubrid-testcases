create table coo(a short, b short);
insert into coo values(12345, 12345);

alter table coo change a a numeric(10, 7), change b b char(4);

select a, length(b) from coo order by 1;


drop table coo;


create table t1 (s1 int);
insert into t1 values(-123);
alter table t1 change s1 s1 char(1);

select * from t1;

drop table t1;
