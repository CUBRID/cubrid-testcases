--+ holdcas on;

drop table if exists t1;

create table t1 (
	a int not null default 0 primary key, 
	b int not null default 0
);
insert into t1 values ( default, default );	
insert into t1 values (1,1),(2,1),(3,1);
select * from t1 order by a,b;
update t1 set a=4 where b=1 order by a limit 0+1+0;
select * from t1 order by a,b;
update t1 set b=2 where b=1 order by a limit 0+2*1;
select * from t1 order by a,b;
update t1 set b=4 where b=1 order by a ;
select * from t1 order by a,b;
delete from t1 where b=2 limit 0+10/9;
select count(*) from t1;
delete from t1 limit 0+1;
select count(*) from t1;
drop table t1;

create table t1 (i int);
insert into t1 (i) values(1),(1),(1);
delete from t1 limit 0+1;
update t1 set i=2 limit 0+1;
delete from t1 limit 0+0;
update t1 set i=3 limit 0+0;
select * from t1;
drop table t1;
select 0 limit 0, 0+0;

create table t1 (a integer);
insert into t1 values (1);
select 1 as a from t1 union all select 1 from db_class limit 0, 0+1;
(select 1 as a from t1) union all (select 1 from db_class) limit 0, 0+1;
drop table t1;

create table t1 (a int);
insert into t1 values (1),(2),(3),(4),(5),(6),(7);
select count(*) c FROM t1 WHERE a > 0 ORDER BY c limit 0, 0+3;
select sum(a) c FROM t1 WHERE a > 0 ORDER BY c limit 0, 0+3;
drop table t1;

prepare s from 'select * from (select 1) limit 0, 0+?';
set @a='qwe';
execute s using @a;
set @a=-1;
execute s using @a;
deallocate prepare s;

prepare s from 'select * from (select 1) limit 0+1, ?';
execute s using @a;
deallocate prepare s;

prepare s from 'select * from (select 1) limit 0+?, ?';
execute s using @a, @a;
set @a=1;
execute s using @a, @a;
set @a=-14632475938453979136;
execute s using @a, @a;
deallocate prepare s;

drop table if exists t1;
drop variable @a;

--+ holdcas off;


