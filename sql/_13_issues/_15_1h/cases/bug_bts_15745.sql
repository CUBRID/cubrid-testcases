--test foreign key
drop table if exists inherit_tbl,t1,ref_tbl;
CREATE TABLE ref_tbl (id INT PRIMARY KEY, a INT);
CREATE TABLE t1 (
id INT,
CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES ref_tbl (id)
);
create table inherit_tbl under t1;
desc inherit_tbl;
alter table t1 drop constraint fk_id;
desc inherit_tbl;
drop table if exists inherit_tbl,t1,ref_tbl;
CREATE TABLE ref_tbl (id INT PRIMARY KEY, a INT);
CREATE TABLE t1 (
id INT,
CONSTRAINT fk_id FOREIGN KEY (id) REFERENCES ref_tbl (id)
);
create table inherit_tbl under t1;
alter table inherit_tbl drop constraint fk_id;
desc inherit_tbl;
drop table if exists inherit_tbl,t1,ref_tbl;

--test unique key
drop table if exists foo,t,t2;
create table t(i int,j varchar(1000),
constraint uk unique key(i,j));
desc t;
create table t2 under t;
desc t2;
alter table t2 drop constraint uk;
desc t2;
alter table t drop constraint uk;
desc t2;
drop table if exists foo,t,t2;
drop table if exists pk_tbl,foo;
CREATE TABLE pk_tbl (a INT, b INT, PRIMARY KEY (a, b DESC));
create table foo under pk_tbl;
alter table foo  drop constraint pk_pk_tbl_a_b_d ;
drop table if exists pk_tbl,foo;



