--+ holdcas on;
drop table if exists t;
CREATE TABLE t (id INT AUTO_INCREMENT PRIMARY KEY , c CHAR(1) UNIQUE);
INSERT INTO t(c) VALUES('a');
select last_insert_id();
INSERT INTO t(c) VALUES ('a') ON DUPLICATE KEY UPDATE id = null;
INSERT INTO t(c) VALUES ('a') ON DUPLICATE KEY UPDATE id = default;
select last_insert_id();
drop table t;


drop table if exists t;
CREATE TABLE t (id INT AUTO_INCREMENT PRIMARY KEY , c CHAR(1) UNIQUE);
INSERT INTO t(c) VALUES('a');
select last_insert_id();
INSERT INTO t(c) VALUES ('a') ON DUPLICATE KEY UPDATE id =  xxxx;
select last_insert_id();
drop table t;



drop table if exists t;
CREATE TABLE t (id INT AUTO_INCREMENT PRIMARY KEY , c CHAR(1) UNIQUE);
INSERT INTO t(id,c) VALUES(null,'a');
INSERT INTO t(id,c) VALUES(default,'b');
select last_insert_id();
INSERT INTO t(c) VALUES ('a') ON DUPLICATE KEY UPDATE id =  last_insert_id()+1;
select last_insert_id();



drop table if exists temp,tempUpdates;
create table temp ( x int primary key , y int, z int);
insert into temp values(1,1,1);
create table tempUpdates like temp;
insert into temp values(2,2,1);
insert into temp (x,y,z) select x,y,z from tempupdates as up 
ON DUPLICATE KEY UPDATE z= y  /*  values(y) */ ;
drop table temp,tempUpdates;



drop table if exists t;
SET @a = 1;
CREATE TABLE t (id INT AUTO_INCREMENT PRIMARY KEY , c CHAR(1) UNIQUE);
INSERT INTO t(c) VALUES('a');
select last_insert_id();
INSERT INTO t(c) VALUES ('a') ON DUPLICATE KEY UPDATE id = @a+1;
INSERT INTO t(c) VALUES ('a') ON DUPLICATE KEY UPDATE id = default;
select last_insert_id();
drop table t;



drop table if exists t,a;
SET @a = 100;
create table t(i int, j int, k int);
create unique index u_t_i on t(i);
create unique index u_t_j_k on t(j, k);
insert into t select rownum, rownum, rownum from _db_class limit 5;
create table a (i int, s varchar(255));
insert into a select rownum, rownum from _db_class limit 5;
select * from t order by 1;
select * from a order by 1;
insert into t (j, k) select i, s from a on duplicate key update i = @a+i;
drop table if exists t,a;


drop table if exists tbl;
CREATE TABLE tbl (color ENUM('red', 'yellow', 'blue') UNIQUE);
insert into tbl values('red');
insert into tbl (color) select 'blue' from tbl on duplicate key update color='yellow';
drop variable @a;
drop table if exists tbl;


--+ holdcas off;
