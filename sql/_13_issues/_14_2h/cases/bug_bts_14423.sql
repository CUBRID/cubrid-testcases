DROP TABLE IF EXISTS tt1;
CREATE TABLE tt1( id INT, col VARCHAR(10));
DROP TABLE IF EXISTS hi;
CREATE TABLE hi( id INT, col VARCHAR(10));
CREATE SERIAL s1;
CREATE TRIGGER trg1 BEFORE INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(s1.NEXT_VALUE,new.col);
drop serial s1;
INSERT INTO tt1 VALUES(2,'Pool');
SELECT * FROM hi;
SELECT * FROM tt1;

delete from hi;
delete from tt1;
CREATE SERIAL s1;
CREATE TRIGGER trg2 after INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(s1.NEXT_VALUE,obj.col);
drop serial s1;
INSERT INTO tt1 VALUES(2,'Pool');
insert into tt1 select rownum,rownum from db_class a,db_class b limit 10;
replace into tt1 values(3,'Beckham');
insert into tt1 values(3,'Beckham') on duplicate key update col='David'; 
insert into hi values(3,'Beckham');
INSERT INTO hi VALUES(s1.NEXT_VALUE,'we');
SELECT * FROM hi;
SELECT * FROM tt1;


delete from hi;
delete from tt1;
create serial s1;
select s1.nextval;
alter serial s1 start with 10;
CREATE TRIGGER trg3 before  INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(s1.NEXT_VALUE,new.col);
drop serial s1;
INSERT INTO tt1 VALUES(2,'Pool');
SELECT * FROM hi;
SELECT * FROM tt1;


delete from hi;
delete from tt1;
create serial s1;
select s1.nextval;
alter serial s1 start with 10;
CREATE TRIGGER trg4 after  INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(s1.NEXT_VALUE,obj.col);
drop serial s1;
INSERT INTO tt1 VALUES(2,'Pool');
SELECT * FROM hi;
SELECT * FROM tt1;
select s1.next_value;
select s1.current_value;


drop trigger trg1;
drop trigger trg2;
drop trigger trg3;
drop trigger trg4;
drop table hi;
drop table tt1;

drop table if exists athlete_idx;
CREATE TABLE athlete_idx( code INT, name VARCHAR(40) );
CREATE SERIAL order_no START WITH 10000 INCREMENT BY 2 MAXVALUE 20000;
drop serial if exists order_no;
INSERT INTO athlete_idx VALUES (order_no.NEXT_VALUE, 'Park');
INSERT INTO athlete_idx VALUES (order_no.NEXT_VALUE, 'Kim');
INSERT INTO athlete_idx VALUES (order_no.NEXT_VALUE, 'Choo');
INSERT INTO athlete_idx VALUES (order_no.CURRENT_VALUE, 'Lee');
drop table athlete_idx;
drop serial order_no;


drop table if exists athlete_idx;
CREATE TABLE athlete_idx( code INT, name VARCHAR(40) );
CREATE SERIAL order_no START WITH 10000 INCREMENT BY 2 MAXVALUE 20000;
INSERT INTO athlete_idx VALUES (order_no.NEXT_VALUE, 'Park');
INSERT INTO athlete_idx VALUES (order_no.NEXT_VALUE, 'Kim');
INSERT INTO athlete_idx VALUES (order_no.NEXT_VALUE, 'Choo');
INSERT INTO athlete_idx VALUES (order_no.CURRENT_VALUE, 'Lee');
select * from athlete_idx order by 1;
drop table athlete_idx;
drop serial order_no;

set system parameters 'insert_execution_mode=0';
DROP TABLE IF EXISTS tt1;
CREATE TABLE tt1( id INT, col VARCHAR(10));
DROP TABLE IF EXISTS hi;
CREATE TABLE hi( id INT, col VARCHAR(10));
CREATE SERIAL s1;
CREATE TRIGGER trg1 BEFORE INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(s1.NEXT_VALUE,new.col);
drop serial s1;
INSERT INTO tt1 VALUES(2,'Pool');
SELECT * FROM hi;
SELECT * FROM tt1;

drop trigger trg1;
drop hi;
drop tt1;


set system parameters 'insert_execution_mode=31';
DROP TABLE IF EXISTS tt1;
CREATE TABLE tt1( id INT, col VARCHAR(10));
DROP TABLE IF EXISTS hi;
CREATE TABLE hi( id INT, col VARCHAR(10));
CREATE SERIAL s1;
CREATE TRIGGER trg1 BEFORE INSERT ON tt1 EXECUTE INSERT INTO hi VALUES(s1.NEXT_VALUE,new.col);
drop serial s1;
SELECT * FROM hi;
SELECT * FROM tt1;
drop trigger trg1;
drop hi;
drop tt1;
set system parameters 'insert_execution_mode=3';
