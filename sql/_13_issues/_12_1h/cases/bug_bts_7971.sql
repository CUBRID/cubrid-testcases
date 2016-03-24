
drop table if exists t1;
create table t1(id int);
insert into t1 values (1);
delete t1.* from t1;
delete t1.* ,t1.* from t1;
drop t1;

drop table if exists t1;
create table t1(id int) partition by hash(id) partitions 3;
insert into t1 values (1);
delete t1.* from t1;
delete t1.* ,t1.* from t1;
drop t1;

drop table if exists t1;
create class t1(id int);
insert into t1 values (1);
delete t1.* ,t1.*,t1.*,t1.*,t1.*,t1.*,t1.*,t1.*,t1.*,t1.*,t1.* from t1;
drop t1;

drop table if exists t1,t2,t3,t4,t5;
create class t1(id int);
insert into t1 values (1);
create class t2(id int);
insert into t2 values (1);
create class t3(id int);
insert into t3 values (1);
create class t4(id int);
insert into t4 values (1);
create class t5(id int);
insert into t5 values (1);
delete t1.*,t2.*,t3.*,t4.*,t5.* from t1,t2,t3,t4,t5;
drop t1,t2,t3,t4,t5;

