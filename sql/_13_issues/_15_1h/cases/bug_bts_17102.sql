drop table if exists t;
drop table if exists t__p__p2;
create table t (i int) partition by range (i) (partition p1 values less than (10), partition p2 values less than (20), partition p3 values less than (30), partition p4 values less than (40));
insert into t values (1);
update t set i=(i/10+1)*10;
update t set i=(i/10+1)*10;
update t set i=(i/10+1)*10;
select * from t__p__p4;
alter table t promote partition p2;
select * from t;
select * from t__p__p4;
select * from t__p__p1;

drop table t__p__p2;
drop table t;
