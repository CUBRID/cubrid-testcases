set system parameters 'create_table_reuseoid=no';
drop table if exists t1;
create table t1(id int primary key, name varchar(20));
drop f,dp;
create table dp(i int primary key);
create table f(i int,j int) partition by range(i) (partition p0 values less than (20),partition p1 values less than (40),
partition p2 values less than(600),partition p3 values less than maxvalue);
drop table if exists t2,actions,t;
create table t2(a int primary key, b smallint, c varchar(100));
create table actions(a int primary key auto_increment, b char(10));
create table t(a int, b string);
insert into t select 0, '0' from db_class w, db_class x, db_class y, db_class z limit 10000;
drop table t;
drop table if exists z1,z2,z3;
create table z1(a int, b int);
create table z2(a int, b int);
create table z3 as select * from z2;
--update set z2.b=(select b from z3 order by 1 desc limit 1)
drop table z1, z2, z3;
create table t(i int primary key) partition by list(i) (partition p0 values in (1),partition p1 values in (2));
--desc t__p__p0;
alter table t promote partition p0;
--desc t__p__p0;
drop t__p__p0, t;
set system parameters 'dont_reuse_heap_file=yes';
create table t(a char(10));
drop table if exists f;
drop table if exists dp;
drop table if exists a;
create table a (i int primary key, j int);
drop a;
set  system parameters 'dont_reuse_heap_file=no';
drop table if exists x1,z2;
create table x1(a varchar(1), b char(1));
create table z2 (a int, b int) partition by hash(b) partitions 2;
insert into t1 values (1, 1), (2, 2), (3, 3);
set system parameters 'dont_reuse_heap_file=yes';
drop table if exists foo,t3,t5;
create table foo(a enum('a', 'b', 'c'));
set system parameters 'dont_reuse_heap_file=no';
create table foo(col1 int primary key auto_increment, col2 date default 'abc');
create table t3(col1 int, col2 date);
create table t5(col1 int);
drop class t5, db_user;
drop t2,t3,t5,foo;
drop table if exists le_inqr,le_ans,t_agntinfo;
set system parameters 'dont_reuse_heap_file=yes';
drop table if exists t;
drop table if exists u;
create table t(i int);
create table u(i int);
drop table t, u;
drop table if exists t2;
set system parameters 'dont_reuse_heap_file = no';
create table t2(a int, b char(10));
drop table t1, t2, actions;
drop table if exists t,u;
create table t(i int) partition by hash(i) partitions 3;
create table u under t(j int);
drop table if exists t;
create table t(i int) partition by range(i) (
        partition p0 values less than (10),
        partition p1 values less than (20),
        partition p2 values less than (30),
        partition p3 values less than (40),
        partition p4 values less than (50),
        partition p5 values less than (60),
        partition p6 values less than (70),
        partition p7 values less than (80),
        partition p8 values less than (90),
        partition p9 values less than (100)
);
alter table t promote partition p1, p3;
alter table t promote partition p5, p6, p9;
alter table t reorganize partition p2 into (partition p1_1 values less than(20), partition p2 values less than(30));
alter table t reorganize partition p4 into (partition p3_1 values less than(40), partition p4 values less than(50));
alter table t promote partition p0, p2, p4, p7, p8;
drop table t__p__p0;
drop table t__p__p1;
drop table t__p__p2;
drop table t__p__p3;
drop table t__p__p6;
drop table t__p__p9;
drop table if exists t;
drop table if exists t__p__p1,t__p__p2;
create table t(i int) partition by list(i) (
    partition p0 values in (1, 2, 3),
    partition p1 values in (4, 5, 6),
    partition p2 values in (7, 8, 9),
    partition p3 values in (10, 11, 12)
);
ALTER TABLE t PROMOTE PARTITION p1, p2;
drop table if exists t;
drop table if exists t__p__p1,t__p__p2;
drop table if exists t2,t1;
create table t2(a int, b char(10));

create table t1(a int, b char(10));
insert into t1 values(1, 'aaa');
insert into t1 values(2, 'bbb');
insert into t1 values(3, 'ccc');
insert into t1 values(4, 'ddd');
insert into t1 values(5, 'eee');

create table t2(a int, b char(10));
insert into t2 values(1, 'AAA');
insert into t2 values(2, 'BBB');
insert into t2 values(4, 'DDD');
insert into t2 values(5, 'EEE');
insert into t2 values(6, 'FFF');
drop view if exists vv;
create view vv as select * from t1 where t1.a > 1;
merge into vv using t2 on (vv.a = t2.a)
when matched then
update set vv.b = left(t2.b,1) where vv.a > 1
delete where left(vv.b,1)='B';

select * from vv order by 1;
select * from t1 order by 1;

drop table t1, t2;
drop view vv;

drop  t__p__p4          ;
drop  t__p__p5          ;
drop  t__p__p7          ;
drop  t__p__p8          ;
drop   u                 ;
drop   x1                ;
drop   z2                ;
drop   z2__p__p0         ;
drop   z2__p__p1    ;

set system parameters 'dont_reuse_heap_file=no';
set system parameters 'create_table_reuseoid=yes';
