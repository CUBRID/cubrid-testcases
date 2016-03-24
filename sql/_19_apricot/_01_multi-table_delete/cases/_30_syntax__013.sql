--SERVER
create class t1(i int, str varchar(255));
insert into t1 values (1, 'one');
insert into t1 values (2, 'two');
insert into t1 values (3, 'three');
insert into t1 values (4, 'four');
insert into t1 values (5, 'five');

create class t2(i int);
insert into t2 values (1), (2), (3), (4), (5);

delete t1.*, t2.* from t1, t2 where t1.i=t2.i and t1.i=1;
select * from t1 order by 1;
select * from t2 order by 1;

delete t1.*, t2.* from t1, t2 where t1.i=t2.i and t1.i=2;
select * from t1 order by 1;
select * from t2 order by 1;

delete t1, t2 from t1, t2 where t1.i=t2.i and t1.i=3;
select * from t1 order by 1;
select * from t2 order by 1;

delete t1 from t1 where i=4;
select * from t1 order by 1;
select * from t2 order by 1;

delete t2 from t2 where i=4;
select * from t1 order by 1;
select * from t2 order by 1;

drop class t1;
drop class t2;