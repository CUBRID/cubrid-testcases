create table t1(i int,j int,primary key(i));
insert into t1 values(1,2),(2,1),(3,1);
create table t2(i int, j int,k int) partition by range(i) (
partition p1 values less than(2),
partition p2 values less than(3),
partition p3 values less than maxvalue);
alter table t2 add constraint foreign key fk(i) references t1(i);
insert into t2 values(3,1,9);

delete from t2 where i=3;
drop t2,t1;

create table t1(i int,j int,primary key(i,j));
insert into t1 values(1,2),(2,1),(3,1);
create table t2(i int, j int,k int) partition by range(i) (
partition p1 values less than(2),
partition p2 values less than(3),
partition p3 values less than maxvalue);
alter table t2 add constraint foreign key fk(i,j) references t1(i,j);
insert into t2 values(3,1,9);
autocommit off;
delete from t2 where i=3;
rollback;
delete from t2 where j=1;
rollback;
delete from t2 where i=3 or j=1;
rollback;
delete from t2 where i=3 and j=1;
rollback;
drop t2,t1;
autocommit on;

create table t1(i int,j int,primary key(i));
insert into t1 values(1,2),(2,1),(3,1);
create table t2(i int, j int,k int) partition by range(i) (
partition p1 values less than(2),
partition p2 values less than(3),
partition p3 values less than maxvalue);
alter table t2 add constraint foreign key fk(i) references t1(i);
insert into t2 values(3,1,9);
alter table t2 promote partition p2;
delete from t2 where i in (3,5);
drop t2,t1,t2__p__p2;
