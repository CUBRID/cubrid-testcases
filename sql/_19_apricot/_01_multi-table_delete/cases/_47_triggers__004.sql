--CLIENT
create class t1(i int);
create class t3(i int, str varchar(255));
create class t4(i int);
create class t5(str varchar(255));

create trigger tr1 before delete on t1 execute delete t4, t3 from t3, t4 where t3.i=t4.i and t3.i=obj.i - 3;
create trigger tr3 before delete on t3 execute insert into t5 values (obj.str);

insert into t1 values (6), (7), (8), (9), (10);
insert into t3 values (1, 't3-1'), (2, 't3-2'), (3, 't3-3'), (4, 't3-4'), (5, 't3-5');
insert into t4 values (1), (2), (3), (4), (5);

delete t1 from t1 where t1.i < 8;
select * from t1 order by 1;
select * from t3 order by 1;
select * from t4 order by 1;
select * from t5 order by 1;

drop class t1;
drop class t3;
drop class t4;
drop class t5;
