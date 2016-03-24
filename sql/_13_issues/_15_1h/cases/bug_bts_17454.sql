--add primary key
drop table if exists t1;
create table t1 (id int ) ;
autocommit off;
insert into t1 values(null);
ALTER TABLE t1 ADD CONSTRAINT pk_t1_id PRIMARY KEY(id);

delete from t1;
select * from t1;
ALTER TABLE t1 ADD CONSTRAINT pk_t1_id PRIMARY KEY(id);
commit;

-- add not null column
drop table if exists t1;
create table t1 (id int );
commit;
insert into t1 values(null);
alter table t1 ADD COLUMN age INT NOT NULL;

delete from t1;
alter table t1 ADD COLUMN age INT NOT NULL;
commit;

--add unique index
drop table if exists t1;
create table t1 (id int ) ;
commit;
insert into t1 values(1);
insert into t1 values(1);
ALTER TABLE t1 ADD CONSTRAINT idx_t1_id unique(id);
delete from t1;
ALTER TABLE t1 ADD CONSTRAINT idx_t1_id unique(id);

--change column
drop table if exists t1;
create table t1 (id int ) ;
insert into t1 values(null);
commit;
insert into t1 values(null);
ALTER TABLE t1 CHANGE id a1 char(5) NOT NULL;
delete from t1 where a1 is null;
select * from t1;

autocommit on;
drop table t1;
commit;

