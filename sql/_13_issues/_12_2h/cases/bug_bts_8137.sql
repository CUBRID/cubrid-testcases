drop table if exists t1;
drop table if exists t2;

create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3);
insert into t2 values (1,1),(2,2);
create index i_t1_a on t1(a);
create index i_t2_a on t2(a);
create view v2 as select * from t2 where a>0 using index i_t2_a keylimit 1,1 order by 1,2;

--below result is good. (1,1), (3,3) were returned.
select t1.*, v2.* from t1 left join v2 on t1.a=v2.a where v2.a is null order by 1, 2;

--we expect (1,1) and (3,3) in table t1 will be updated. In fact, only (3,3) was updated.
update t1 left join v2 on t1.a=v2.a set t1.b=100, v2.b=100 where v2.a is null ;

--we expect (1,1) and (3,3) in table t1 will be deleted. In fact, only (3,3) was deleted.
delete t1.*, v2.* from t1 left join v2 on t1.a=v2.a where v2.a is null;

select * from t1 order by 1, 2;
select * from t2 order by 1, 2;

drop view v2;
drop table t1;
drop table t2;
create table t1(a int, b int);
create table t2(a int, b int);
insert into t1 values (1,1),(2,2),(3,3);
insert into t2 values (1,1),(2,2);
create view v2 as select * from t2 order by a desc limit 1;

--below result is good. (1,1), (3,3) were returned.
select t1.*, v2.* from t1 left join v2 on t1.a=v2.a where v2.a is null order by 1, 2;

--we expect (1,1) and (3,3) in table t1 will be updated. In fact, only (3,3) was updated.
update t1 left join v2 on t1.a=v2.a set t1.b=100, v2.b=100 where v2.a is null ;

--we expect (1,1) and (3,3) in table t1 will be deleted. In fact, only (3,3) was deleted.
delete t1.*, v2.* from t1 left join v2 on t1.a=v2.a where v2.a is null;

select * from t1 order by 1, 2;
select * from t2 order by 1, 2;

drop view v2;
drop table t1;
drop table t2;

create table t1(a int, b int) partition by hash(a) partitions 3; 
create table t2(a int, b int) partition by hash(b) partitions 3; 
insert into t1 values (1,1),(2,2),(3,3);
insert into t2 values (1,1),(2,2);
create view v2 as select * from t2 order by a desc limit 1;

--below result is good. (1,1), (3,3) were returned.
select t1.*, v2.* from t1 left join v2 on t1.a=v2.a where v2.a is null order by 1, 2;

--we expect (1,1) and (3,3) in table t1 will be updated. In fact, only (3,3) was updated.
update t1 left join v2 on t1.a=v2.a set t1.b=100, v2.b=100 where v2.a is null ;

--we expect (1,1) and (3,3) in table t1 will be deleted. In fact, only (3,3) was deleted.
delete t1.*, v2.* from t1 left join v2 on t1.a=v2.a where v2.a is null;

select * from t1 order by 1, 2;
select * from t2 order by 1, 2;

drop view v2;
drop table t1;
drop table t2;
