drop table if exists t1;
drop table if exists t2;

create table t1(i int not null primary key) partition by range (i) (partition p0 values less than (100), partition p1 values less than (100000));
insert into t1 values (1), (2), (3);
create table t2(i int, foreign key (i) references t1(i) on delete set null on update restrict);
insert into t2 values (1), (2);
select * from t1;
select * from t2;
update t1 set i=5 where i=1;
update t1 set i=1000 where i=2;
select * from t1;
select * from t2;

drop table if exists t2;
drop table if exists t1;
