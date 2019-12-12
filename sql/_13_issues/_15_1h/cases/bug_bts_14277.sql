-----insert in client mode-----------
set system parameters 'insert_execution_mode=25';
drop table if exists tbl_flag;
drop table if exists tbl1;
drop table if exists tbl2;
CREATE TABLE tbl_flag (id INT AUTO_INCREMENT(1111,1));
INSERT INTO tbl_flag VALUES(NULL);
CREATE TABLE tbl1 (id INT AUTO_INCREMENT(10,1));
CREATE TABLE tbl2 (id INT AUTO_INCREMENT(100,1), last_id INT);
CREATE TRIGGER t1 AFTER INSERT ON tbl1 EXECUTE INSERT INTO tbl2 VALUES(NULL, LAST_INSERT_ID());
INSERT INTO tbl1 VALUES(NULL); 
select * from tbl2;
drop trigger t1;
drop table if exists tbl_flag;
drop table if exists tbl1;
drop table if exists tbl2;
set system parameters 'insert_execution_mode=3';

-----insert in server mode-----------
drop table if exists tbl_flag;
drop table if exists tbl1;
drop table if exists tbl2;
CREATE TABLE tbl_flag (id INT AUTO_INCREMENT(1111,1));
INSERT INTO tbl_flag VALUES(NULL);
CREATE TABLE tbl1 (id INT AUTO_INCREMENT(10,1));
CREATE TABLE tbl2 (id INT AUTO_INCREMENT(100,1), last_id INT);
CREATE TRIGGER t1 AFTER INSERT ON tbl1 EXECUTE INSERT INTO tbl2 VALUES(NULL, LAST_INSERT_ID());
INSERT INTO tbl1 VALUES(NULL);
select * from tbl2;
drop trigger t1;
drop table if exists tbl_flag;
drop table if exists tbl1;
drop table if exists tbl2;
