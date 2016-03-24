--CLIENT
create class t1(i int, str varchar(255));
create class t2(i int, str varchar(255));
create class t3(i int, str varchar(255));

create trigger tr1 before delete on t1 execute insert into t3 values (100 + obj.i, obj.str);
create trigger tr2 before delete on t2 execute insert into t3 values (100 + obj.i, obj.str);

insert into t1 values (1, 't1-1'), (2, 't1-2'), (3, 't1-3'), (4, 't1-4'), (5, 't1-5');
insert into t2 values (6, 't2-6'), (7, 't2-7'), (8, 't2-8'), (9, 't2-9'), (10, 't2-10');
insert into t3 values (0, '');

delete t1, t2 from t1 inner join t2 on t1.i=t2.i-3;
select * from t1 order by 1;
select * from t2 order by 1;
select * from t3 order by 1;

drop class t1;
drop class t2;
drop class t3;