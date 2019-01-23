drop table if exists a,b;
CREATE TABLE a(id INT PRIMARY KEY, charge DOUBLE,c timestamp on update current_timestamp);
CREATE TABLE b(rate_id INT, rate DOUBLE);
INSERT INTO a(id,charge) VALUES (1, 100.0), (2, 1000.0), (3, 10000.0);
INSERT INTO b VALUES (1, 0.1), (2, 0.0), (3, 0.2), (3, 0.5);

UPDATE
 a INNER JOIN b ON a.id=b.rate_id
SET
  a.charge = a.charge * (1 + b.rate)
WHERE a.charge > 900.0;
select if(current_timestamp -c>=0 and current_timestamp -c<10,'ok','nok') from a where a.charge>900;


drop table if exists tbl1,tbl2;
CREATE TABLE tbl1(a INT, b INT,c timestamp on update current_timestamp);
CREATE TABLE tbl2(a INT, b INT,c timestamp on update current_timestamp);
INSERT INTO tbl1(a,b) VALUES (5,5),(4,4),(3,3),(2,2),(1,1);
INSERT INTO tbl2(a,b) VALUES (6,6),(4,4),(3,3),(2,2),(1,1);
CREATE or replace VIEW vw AS SELECT tbl2.* FROM tbl2 LEFT JOIN tbl1 ON tbl2.a=tbl1.a WHERE tbl2.a<=3;
select * from vw order by 1;
UPDATE vw SET a=1;
select * from tbl1 order by 1 desc;
select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from tbl2 where a=1;
select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from vw;


drop table if exists tbl1,tbl2;
CREATE TABLE tbl1(a INT, b INT,c timestamp on update current_timestamp);
CREATE TABLE tbl2(a INT, b INT,c timestamp on update current_timestamp);
INSERT INTO tbl1(a,b) VALUES (5,5),(4,4),(3,3),(2,2),(1,1);
INSERT INTO tbl2(a,b) VALUES (6,6),(4,4),(3,3),(2,2),(1,1);
CREATE or replace VIEW vw AS SELECT tbl2.* FROM tbl2 inner JOIN tbl1 ON tbl2.a=tbl1.a WHERE tbl2.a<=3;
select * from vw;
UPDATE vw SET a=1000;
select * from vw;
select * from tbl1 order by 1 desc;
select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from tbl2 where a=1000;


drop table if exists tbl1,tbl2;
CREATE TABLE tbl1(a INT, b INT,c timestamp on update current_timestamp);
CREATE TABLE tbl2(a INT, b INT,c timestamp on update current_timestamp);
INSERT INTO tbl1(a,b) VALUES (5,5),(4,4),(3,3),(2,2),(1,1);
INSERT INTO tbl2(a,b) VALUES (6,6),(4,4),(3,3),(2,2),(1,1);
UPDATE tbl1,tbl2 SET tbl1.a=1000,tbl2.a=2000;
select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from tbl2;
select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from tbl1;

drop table if exists tbl2,tbl1;
CREATE TABLE tbl1(a INT primary key, b INT,c timestamp on update current_timestamp);
CREATE TABLE tbl2(a INT, b INT,c timestamp on update current_timestamp,foreign key fk(a) references tbl1(a));
INSERT INTO tbl1(a,b) VALUES (6,6),(5,5),(4,4),(3,3),(2,2),(1,1);
INSERT INTO tbl2(a,b) VALUES (5,6),(4,4),(3,3),(2,2),(1,1);
 UPDATE tbl1,tbl2 SET tbl1.a=8,tbl2.a=8 where tbl1.a=6 and tbl2.a=5;
select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from tbl1 where a=8;
select if(current_timestamp-c>=0 and current_timestamp-c<10,'ok','nok') from tbl2 where a=8;
drop if exists tbl2,tbl1;
drop if exists a,b,vw;
