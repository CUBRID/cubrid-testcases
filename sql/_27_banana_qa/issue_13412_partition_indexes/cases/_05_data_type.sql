drop table if exists t1;
create table t1(i date) partition by hash(i) partitions 5;
insert into t1 values('1990-12-1');
insert into t1 values('1998-12-1');
insert into t1 values('1993-12-1');
insert into t1 values('1988-12-1');
insert into t1 values('1953-2-24');
alter table t1 add constraint pk_t1_i primary key(i);
show tables;
update statistics on t1 with fullscan;
show index from t1__p__p0;
show index from t1__p__p1;
show index from t1__p__p2;
show index from t1__p__p3;
show index from t1__p__p4;
alter table t1 add column j time;
alter table t1 add constraint u_t1_j unique(j);
alter table t1 add constraint u_t1_j_i unique(j,i);
alter table t1 add constraint u_t1_i unique(i);
alter table t1 add column k enum('1','2','3');
alter table t1 add constraint u_t1_j_k unique(j,k);
alter table t1 add constraint u_t1_j_i_k unique(j,i,k);
alter table t1 add constraint u_t1_i_k unique(i,k);
 select count(distinct i) from t1__p__p0;
 show index from t1__p__p0;
select count(distinct i) from t1__p__p1;
 show index from t1__p__p1;
drop table t1;

drop table if exists members;
CREATE TABLE members (
    id INT,
    fname VARCHAR(25),
    lname VARCHAR(25),
    dob int primary key
)
PARTITION BY RANGE( dob ) (
    PARTITION p0 VALUES LESS THAN (1970),
    PARTITION p1 VALUES LESS THAN (1980),
    PARTITION p2 VALUES LESS THAN (1990)
);
ALTER TABLE members ADD PARTITION (PARTITION p3 VALUES LESS THAN (2000));
ALTER TABLE members ADD PARTITION (PARTITION p4 VALUES LESS THAN (1996));
ALTER TABLE members
    REORGANIZE PARTITION p0 INTO (
        PARTITION n0 VALUES LESS THAN (1960),
        PARTITION n1 VALUES LESS THAN (1970)
);
show tables;
show index from members__p__p0;
show index from members__p__p1;
show index from members__p__p2;
show index from members__p__n0;
show index from members__p__n1;
insert into members(dob) values(1954),(1964),(1974),(1984),(1994);
update statistics on members with fullscan;
create unique index idx_u_dod on members(dob);
show index from members__p__p0;
show index from members__p__p1;
show index from members__p__p2;
show index from members__p__n0;
show index from members__p__n1;
ALTER TABLE members REORGANIZE PARTITION n0,n1 INTO (
    PARTITION p0 VALUES LESS THAN (1970)
);
update statistics on all classes  with fullscan;
show index from members__p__p0;
show index from members__p__p1;
show index from members__p__p2;
show index from members__p__n0;
show index from members__p__n1;
drop table members;

drop table if exists tt;
CREATE TABLE tt (
    id INT,
    `data` INT
)
PARTITION BY LIST(`data`) (
    PARTITION p0 VALUES IN (5, 10, 15),
    PARTITION p1 VALUES IN (6, 12, 18)
);
ALTER TABLE tt ADD PARTITION (PARTITION p2 VALUES IN (7, 14, 21));
ALTER TABLE tt ADD PARTITION (PARTITION p3 VALUES IN (4, 8, 23));
ALTER TABLE tt ADD PARTITION (PARTITION p4 VALUES IN (3, 16, 22));
insert into tt values(3,3),(4,4),(5,5),(6,6),(7,7);
insert into tt values(8,8),(10,10),(12,12),(14,14),(16,16);
 insert into tt values(15,15),(18,18),(21,21),(22,22),(23,23);
 create index idx1 on tt(id);
 create index idx2 on tt(`data`);
 create unique index idx3 on tt(id desc);
 create unique index idx4 on tt(`data` desc);
 create unique index idx5 on tt(id,`data`);
 create unique index idx6 on tt(id,`data` desc);
 update statistics on all classes  with fullscan;
show index from tt__p__p0;
show index from tt__p__p1;
show index from tt__p__p2;
drop table tt;

drop table if exists employees;
CREATE TABLE employees (
  id INT NOT NULL,
  fname VARCHAR(50) NOT NULL,
  lname VARCHAR(50) NOT NULL,
  hired DATE NOT NULL primary key
)
PARTITION BY RANGE( YEAR(hired) ) (
  PARTITION p1 VALUES LESS THAN (1991),
  PARTITION p2 VALUES LESS THAN (1996),
  PARTITION p3 VALUES LESS THAN (2001),
  PARTITION p4 VALUES LESS THAN (2005)
);
alter table employees drop constraint pk_employees_hired;
update statistics on employees;
show index from employees;
alter table employees add  constraint pk_employees_hired primary key(hired);
alter table employees add  constraint pk_employees_hired_id primary key(id,hired);
alter table employees add  constraint u_employees_hired_id unique(id,hired);
alter table employees add  constraint u_employees_id unique(id);
drop table employees;
