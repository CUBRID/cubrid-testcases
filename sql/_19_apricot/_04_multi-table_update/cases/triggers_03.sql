--CLIENT
create class t1(i int);
create class t3(i int);
create class t4(i int);

create trigger tr1 before update on t1 execute update t3, t4 set t4.i=t4.i + obj.i, t3.i=t3.i + obj.i where t3.i=t4.i;

insert into t1 values (1), (2), (3), (4), (5);
insert into t3 values (6), (7), (8), (9), (10);
insert into t4 values (7), (8), (9), (10), (11);

update t1 set t1.i=t1.i + 1 where t1.i > 3;
select * from t1 order by 1;
select * from t3 order by 1;
select * from t4 order by 1;

drop class t1;
drop class t3;
drop class t4;
