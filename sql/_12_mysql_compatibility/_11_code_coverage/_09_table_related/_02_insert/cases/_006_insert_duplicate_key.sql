-- INSERT  ... ON DUPLICATE KEY UDPATE 

create table t1 (i1 integer, c integer);

insert into t1 values (1,0),(2,0) on duplicate key update c=c+1;;
insert into t1 set i1=1 on duplicate key update c=c+1;
drop table t1;

create table t1 (i1 integer primary key, c integer);
create unique index u_idx on t1(c); 

insert into t1 values (1,0),(2,0) on duplicate key update c=c+1;
insert into t1 set i1=1 on duplicate key update c=c+1;
drop table t1;

create table t1 (i1 integer, c integer, primary key(i1,c)) partition by hash(c) partitions 4;
create unique index u_idx on t1(c); 
replace into t1 values (1,0),(2,0), (2,1);

drop table t1;



create table t1 (i1 integer default 0);

create table t2 (i2 integer );

create unique index u_idx  on t2(i2);

insert into t1 values (2),(4),(5);
select * from t1 order by 1 desc;

-- should fail on execution
insert into t1 values (2),(4),(5);
select * from t1 order by 1 desc;

insert into t2(i2) select i1 from t1 on duplicate key update i2=-1;
select * from t1 order by 1 desc;

-- should fail
insert into t2_2(i2) select i1 from t1 on duplicate key update i2=-1;

drop table t1;
drop table t2;
