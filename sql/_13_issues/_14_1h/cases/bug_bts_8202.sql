drop table if exists t1;
drop table if exists t2;

create  table  t1 (a int primary key, b int);
create  table  t2 (a int primary key, b int);

insert  into t1  values (10, 20);
insert  into t2  values (10, 20);

update t1, t2 set t1.b=150 , t2.b=t1.b where t2.a = t1.a and t1.a = 10;

select * from t1 order by 1, 2;

select * from t2 order by 1, 2;

delete from t1;
delete from t2;

insert  into t1  values (10, 20);
insert  into t2  values (10, 20);

set system parameters 'update_use_attribute_references=yes';

update t1, t2 set t1.b=150 , t2.b=t1.b where t2.a = t1.a and t1.a = 10;

select * from t1 order by 1, 2;

select * from t2 order by 1, 2;

drop table t1;
drop table t2;

set system parameters 'update_use_attribute_references=no';

create table t(i int, j int, s varchar(255), d date);

insert into t select rownum, rownum, rownum , date'2010-01-01' + rownum from _db_class limit 5;

update t set j = 100, s = j + 2 where i = 1;

select j, s from t where i = 1;

update t set j = s + 100, s = j + 5 where i = 2;

select j, s from t where i = 2;

update t set d = d + i, s = d where i = 3;

select s, d from t where i = 3;

delete from t;

set system parameters 'update_use_attribute_references=yes';

insert into t select rownum, rownum, rownum , date'2010-01-01' + rownum from _db_class limit 5;

update t set j = 100, s = j + 2 where i = 1;

select j, s from t where i = 1;

update t set j = s + 100, s = j + 5 where i = 2;

select j, s from t where i = 2;

update t set d = d + i, s = d where i = 3;

select s, d from t where i = 3;

drop table t;

set system parameters 'update_use_attribute_references=no';
