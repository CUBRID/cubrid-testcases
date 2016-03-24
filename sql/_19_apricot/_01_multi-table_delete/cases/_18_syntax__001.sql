--SERVER
create class t1 (i int);
insert into t1 values (1), (2), (3), (4), (5);

create class t2 (i int);
insert into t2 values (4), (5), (6), (7), (8);

delete from t1 where i < 2;
select * from t1 order by 1;

delete t1 from t1 where i < 3;
select * from t1 order by 1;

delete from t1, t2;
delete t1, t2 from t1;
delete t1, t3 from t1, t2;
delete from using t1 where i < 4;
select * from t1 order by 1;

delete from t1 using t1 where i < 5;
select * from t1 order by 1;

delete from using t1, t2;
delete from t1, t2 using t1;
delete from t1, t3 using t1, t2;
delete t2 order by i asc;
delete t1, t2 from t1, t2 limit 1;

create index idx on t2(i);
delete t1, t2 from t1, t2 using index idx;

drop class t1;
drop class t2;
