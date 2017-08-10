
drop if exists c,tbl1,tbl2;

set system parameters 'insert_execution_mode=25';
create table c (a numeric(38,0) auto_increment(9223372036854775807,1), b int);
insert into c(b) values (1);
select last_insert_id();
CREATE TABLE tbl1 (id INT AUTO_INCREMENT NOT NULL PRIMARY KEY);
CREATE TABLE tbl2 (id INT AUTO_INCREMENT(100,1), last_id INT);
CREATE TRIGGER t1 AFTER INSERT ON tbl1 EXECUTE INSERT INTO tbl2 VALUES(NULL, LAST_INSERT_ID());
INSERT INTO tbl1 VALUES(NULL);
drop trigger t1;
drop if exists c,tbl1,tbl2;

set system parameters 'insert_execution_mode=3';
create table c (a numeric(38,0) auto_increment(9223372036854775807,1), b int);
insert into c(b) values (1);
select last_insert_id();
CREATE TABLE tbl2 (id INT AUTO_INCREMENT(100,1), last_id INT);
INSERT INTO tbl2 VALUES(NULL, LAST_INSERT_ID());
drop if exists c,tbl1,tbl2;

set system parameters 'insert_execution_mode=25';
create table c (a numeric(38,0) auto_increment(9223372036854775807,1), b int);
insert into c(b) values (1);
select last_insert_id();
CREATE TABLE tbl2 (id INT AUTO_INCREMENT(100,1), last_id INT);
INSERT INTO tbl2 VALUES(NULL, LAST_INSERT_ID());
drop if exists c,tbl1,tbl2;

set system parameters 'insert_execution_mode=3';

