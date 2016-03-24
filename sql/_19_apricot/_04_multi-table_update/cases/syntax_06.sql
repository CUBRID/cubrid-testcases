--CLIENT
create class t_tr(i1 int, i2 int, i3 varchar(255), i4 float, i5 date, tbl varchar(255));

create table t1 (i1 int, i2 int, i3 varchar(255), i4 float, i5 date);
create trigger tr1 before update on t1 execute insert into t_tr values(obj.i1, obj.i2, obj.i3, obj.i4, obj.i5, 't1');
insert into t1 values (1, 2, '3', 4, '09/22/2011');
insert into t1 values (10, 20, '30', 40, '09/23/2011');
insert into t1 values (100, 200, '300', 400, '09/24/2011');

create table t2 (i1 int, i2 int, i3 varchar(255), i4 float, i5 date);
create trigger tr2 before update on t2 execute insert into t_tr values(obj.i1, obj.i2, obj.i3, obj.i4, obj.i5, 't2');
insert into t2 values (-1, -2, '-3', -4,'09/25/2011');
insert into t2 values (-10, -20, '-30', -40, '09/26/2011');
insert into t2 values (-100, -200, '-40', -400, '09/27/2011');

update t1 inner join t2 on t1.i1=-t2.i1 set t2.i3=t1.i3, t2.i1=t1.i1, t1.i3='jjj', t1.i2=t2.i1, t1.i4=t2.i4, t2.i2=t2.i3, t2.i4=8, t1.i1=t2.i2, t1.i5=t2.i5, t2.i5=t1.i5;

select * from t1 order by 1, 2, 3, 4, 5;
select * from t2 order by 1, 2, 3, 4, 5;
select * from t_tr order by 1, 2, 3, 4, 5;

drop table t1;
drop table t2;
drop table t_tr;