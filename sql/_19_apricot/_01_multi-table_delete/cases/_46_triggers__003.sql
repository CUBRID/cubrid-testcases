--CLIENT
create class t1(i int, str varchar(255));
create class t3(i int);
create class t4(i int);

create trigger tr1 before delete on t1 execute delete t3, t4 from t3, t4 where t3.i=t4.i and t3.i=obj.i + 3;

insert into t1 values (1, 't1-1'), (2, 't1-2'), (3, 't1-3'), (4, 't1-4'), (5, 't1-5');
insert into t3 values (6), (7), (8), (9), (10);
insert into t4 values (7), (8), (9), (10), (11);

delete t1 from t1 where i > 3;
select * from t1 order by 1;
select * from t3 order by 1;
select * from t4 order by 1;

drop class t1;
drop class t3;
drop class t4;
