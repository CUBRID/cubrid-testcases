drop table if exists t1;

create table t1(a int);
insert into t1 values (1),(2),(3);
create view v1 as select * from t1;
create view v2 as select * from v1;
create view v3 as select v1.* from v1, v2;
create view v4 as select v1.* from v1, v2,v3;

drop table if exists t1;
select * from v3 order by 1;
select * from v4 order by 1;

drop view v1,v2,v3,v4;

create table t1(a int);
insert into t1 values (1),(2),(3);
create view v1 as select * from t1;
create view v2 as select * from v1;
create view v3 as select v1.* from v1, v2;
create view v4 as select v1.* from v1, v2,v3;
create view v5 as select v1.* from v1, v2,v3;

drop table if exists t1;
select * from v3 order by 1;
select * from v4 order by 1;

drop view v1,v2,v3,v4,v5;

create table t1(a int) partition by hash(a) partitions 3;
insert into t1 values (1),(2),(3);
create view v1 as select * from t1;
create view v2 as select * from v1;
create view v3 as select v1.* from v1, v2;
create view v4 as select v1.* from v1, v2,v3;

drop table if exists t1;
select * from v3 order by 1;
select * from v4 order by 1;

drop view v1,v2,v3,v4;





