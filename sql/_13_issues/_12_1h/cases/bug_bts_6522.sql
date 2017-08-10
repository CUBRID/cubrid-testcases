create table t1 (a int auto_increment primary key)  partition by list (a) (partition p0 values in (1, 2));
INSERT INTO t1 VALUES (NULL),(NULL);
select * from t1;

drop t1;
create table t1 (a int auto_increment(2,3) primary key)  partition by list (a) (partition p0 values in (1, 2));
INSERT INTO t1 VALUES (NULL),(NULL);
select * from t1;

drop t1;
create table t1 (a int auto_increment(-2,3) primary key)  partition by list (a) (partition p0 values in (-2, 1));
INSERT INTO t1 VALUES (NULL),(NULL);
select * from t1;

drop t1;
create table t1 (a int auto_increment(1,4) primary key)  partition by list (a) (partition p0 values in (1, 5));
create table temp(i int);
insert into temp values(NULL);
INSERT INTO t1 select * from temp;
INSERT INTO t1 select * from temp;
INSERT INTO t1 select * from temp;
select * from t1;

drop t1;
drop temp;