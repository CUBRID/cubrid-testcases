drop table if exists t1;
create table t1(id int);
insert into t1 values (1),(2);
--Yes, below is supported by CUBRID. But MySQL doesn't support.
delete t1.id from t1;

--below is NOT supported by CUBRID. But MySQL support.
delete t1.* from t1;
drop t1;

drop table if exists t2;
create table t1 (a int, b int);
create table t2 (b int, c int);

-- DELETE t.* tests FROM
insert into t1 values (1, 1);
insert into t2 values (1, 2);
delete t1.* from t1 inner join t2 on t1.b = t2.b;
select * from t1 order by b;
select * from t2 order by b;

insert into t1 values (1, 1);
delete t2.* from t1 inner join t2 on t1.b = t2.b;
select * from t1 order by b;
select * from t2 order by b;

insert into t2 values (1, 2);
delete t1.*, t2.* from t1 inner join t2 on t1.b = t2.b;
select * from t1 order by b;
select * from t2 order by b;

insert into t1 values (1, 1);
insert into t2 values (1, 2);
delete t1.* from t1, t2;
select * from t1 order by b;
select * from t2 order by b;

insert into t1 values (1, 1);
delete t1.*, t2.* from t1, t2;
select * from t1 order by b;
select * from t2 order by b;

-- DELETE t.c FROM
insert into t1 values (1, 1);
insert into t2 values (1, 2);
delete t1.a from t1 inner join t2 on t1.b = t2.b;
select * from t1 order by b;
select * from t2 order by b;

insert into t1 values (1, 1);
delete t2.c from t1 inner join t2 on t1.b = t2.b;
select * from t1 order by b;
select * from t2 order by b;

insert into t2 values (1, 2);
delete t1.b, t2.b from t1 inner join t2 on t1.b = t2.b;
select * from t1 order by b;
select * from t2 order by b;

insert into t1 values (1, 1);
insert into t2 values (1, 2);
delete t1.b from t1, t2;
select * from t1 order by b;
select * from t2 order by b;

insert into t1 values (1, 1);
delete t1.b, t2.b from t1, t2;
select * from t1 order by b;
select * from t2 order by b;


insert into t1 values (1, 1);
insert into t2 values (1, 2);
delete dba.t1 from t1 inner join t2 on t1.b = t2.b;
delete whatever.t1 from t1 inner join t2 on t1.b = t2.b;
delete t1.c from t1 inner join t2 on t1.b = t2.b;
delete b.t1 from t1 inner join t2 on t1.b = t2.b;
delete t2.t1 from t1 inner join t2 on t1.b = t2.b;

drop table t1;
drop table t2;

