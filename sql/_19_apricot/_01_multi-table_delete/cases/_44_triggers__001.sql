--CLIENT
create class t1(i int);
create class t2(i int);
create class t3(str varchar(255));

create trigger tr1 before statement delete on t1 execute insert into t3 values ('t1');
create trigger tr2 before statement delete on t2 execute insert into t3 values ('t2');

insert into t1 values (1), (2), (3), (4), (5);
insert into t2 values (6), (7), (8), (9), (10);

delete t1, t2 from t1 inner join t2 on t1.i=t2.i-3;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

drop class t1;
drop class t2;
drop class t3;