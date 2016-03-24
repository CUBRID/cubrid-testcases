create table t1 (a int not null, b int not null, c int not null);
create index t1_abc on t1(a,b,c);

select * from t1 order by a desc;

drop table t1;
