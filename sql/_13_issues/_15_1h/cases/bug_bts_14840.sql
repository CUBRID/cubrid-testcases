AUtocommit off;
drop table if exists t;
create table t(id int primary key,col varchar(10)) partition by range(id)(partition p1 values less than (100),partition p2 values less than (500));
INSERT INTO t SELECT rownum,rownum||'abcdef' FROM db_class a,db_class b limit 500;
INSERT INTO t SELECT rownum,rownum||'abcdef' FROM db_class a,db_class b limit 499;
select count(*) from t;
drop table t;

drop table if exists t1;
create table t1 (id int auto_increment primary key,name char(30));
insert into t1 values(4000,'afsddddddddddddddddddddddddd');
insert into t1(id,name) select rownum,rownum||'asdfffffffffffffffafds' from db_class a,db_class b,db_class c limit 4001;
insert into t1(id,name) select rownum,rownum||'asdfffffffffffffffafds' from db_class a,db_class b,db_class c limit 3998;
select count(*) from t1;
drop table t1;
commit;
AUtocommit on;
