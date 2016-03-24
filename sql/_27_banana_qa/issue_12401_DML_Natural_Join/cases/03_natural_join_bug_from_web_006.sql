--03_natural_join_bug_from_web_006.sql
drop table if exists t1,t2;
CREATE TABLE t1(a INTEGER);
CREATE TABLE t2(a INTEGER);
INSERT INTO t1 VALUES (11);
INSERT INTO t1 VALUES (12);
INSERT INTO t2 VALUES (10);
INSERT INTO t2 VALUES (12);

--
SELECT * from (select * from t1 order by 1) t1 join (select * from t2 order by 1) t2 ON t1.a=t2.a;
UPDATE t1 join t2 ON t1.a=t2.a SET t1.a=100;
select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

UPDATE t1 join t2 ON t1.a=t2.a SET t1.a=100,t2.a=2;

select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 join t2 ON t1.a=t2.a SET t1.a=100,t2.a=2,t1.a=20;

select * from t1 order by 1;
select * from t2 order by 1;
----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 join t2 ON t1.a=t2.a SET t1.a=100,t2.a=2 where t1.a = 12;

select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 join t2 ON t1.a!=t2.a SET t1.a=100,t2.a=2 where t1.a = 100;

select * from t1 order by 1;
select * from t2 order by 1;

------------------------
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

UPDATE t1 natural join t2 SET t1.a=100;
select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

UPDATE t1 natural join t2 SET t1.a=100,t2.a=2;

select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 natural join t2 SET t1.a=100,t2.a=2,t1.a=20;

select * from t1 order by 1;
select * from t2 order by 1;
----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 natural join t2 SET t1.a=100,t2.a=2 where t1.a = 12;

select * from t1 order by 1;
select * from t2 order by 1;


----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 natural join t2 SET t1.a=100,t2.a=2 where t1.a = 100;

select * from t1 order by 1;
select * from t2 order by 1;


------------------------
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

UPDATE t1 natural left join t2 SET t1.a=100;
select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

UPDATE t1 natural left join t2 SET t1.a=100,t2.a=2;

select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 natural left join t2 SET t1.a=100,t2.a=2,t1.a=20;

select * from t1 order by 1;
select * from t2 order by 1;
----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 natural left join t2 SET t1.a=100,t2.a=2 where t1.a = 12;

select * from t1 order by 1;
select * from t2 order by 1;


----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 natural left join t2 SET t1.a=100,t2.a=2 where t1.a = 100;

select * from t1 order by 1;
select * from t2 order by 1;

------------------------
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

UPDATE t1 natural right join t2 SET t1.a=100;
select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

UPDATE t1 natural right join t2 SET t1.a=100,t2.a=2;

select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 natural right join t2 SET t1.a=100,t2.a=2,t1.a=20;

select * from t1 order by 1;
select * from t2 order by 1;
----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 natural right join t2 SET t1.a=100,t2.a=2 where t1.a = 12;

select * from t1 order by 1;
select * from t2 order by 1;


----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);
UPDATE t1 natural right join t2 SET t1.a=100,t2.a=2 where t1.a = 100;

select * from t1 order by 1;
select * from t2 order by 1;


------------------------
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

delete t1 from t1 join t2;

select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

delete t1 from t1 natural join t2;

select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

delete t1 from t1 natural left join t2;

select * from t1 order by 1;
select * from t2 order by 1;

----
delete from t1;
delete from t2;
INSERT INTO t1 VALUES (11),(12);
INSERT INTO t2 VALUES (10),(12);

delete t1 from t1 natural right join t2;

select * from t1 order by 1;
select * from t2 order by 1;

drop table if exists t1,t2;
-----------------------------------------------

drop table a;
drop table b;
drop table c;
drop table d;
CREATE TABLE a (
	id INT NOT NULL ,
	dd INT
);

CREATE TABLE b (
	id INT NOT NULL ,
	a_id INT NOT NULL
);

CREATE TABLE c (
	id INT NOT NULL 
) ;

CREATE TABLE d (
	id INT NOT NULL ,
	b_id INT NOT NULL,
	c_id INT NULL
) ;


-----
DELETE FROM A;
DELETE FROM B;
DELETE FROM C;
DELETE FROM D;

INSERT INTO a VALUES (1, 123);
INSERT INTO a VALUES (2, 456);
INSERT INTO a VALUES (3, 123);

INSERT INTO b VALUES (1, 1);
INSERT INTO b VALUES (2, 2);
INSERT INTO b VALUES (3, 3);
INSERT INTO b VALUES (4, 3);

INSERT INTO c VALUES (1);
INSERT INTO c VALUES (2);
INSERT INTO c VALUES (3);
INSERT INTO c VALUES (4);
INSERT INTO c VALUES (5);
INSERT INTO c VALUES (6);

INSERT INTO d VALUES (1, 1, 1);
INSERT INTO d VALUES (2, 2, 2);
INSERT INTO d VALUES (3, 3, 3);
INSERT INTO d VALUES (4, 4, 4);
INSERT INTO d VALUES (5, 4, 5);


SELECT a.*,c.* FROM a
LEFT JOIN b ON b.a_id = a.id
LEFT JOIN d ON d.b_id = b.id
LEFT JOIN c ON c.id = d.c_id
WHERE a.dd = 123 order by 1,2,3;

DELETE a FROM a
LEFT JOIN b ON b.a_id = a.id
LEFT JOIN d ON d.b_id = b.id
LEFT JOIN c ON c.id = d.c_id
WHERE a.dd = 123;

SELECT a.*,c.* FROM a
LEFT JOIN b ON b.a_id = a.id
LEFT JOIN d ON d.b_id = b.id
LEFT JOIN c ON c.id = d.c_id
WHERE a.dd = 123 order by 1,2,3;


-----
DELETE FROM A;
DELETE FROM B;
DELETE FROM C;
DELETE FROM D;

INSERT INTO a VALUES (1, 123);
INSERT INTO a VALUES (2, 456);
INSERT INTO a VALUES (3, 123);

INSERT INTO b VALUES (1, 1);
INSERT INTO b VALUES (2, 2);
INSERT INTO b VALUES (3, 3);
INSERT INTO b VALUES (4, 3);

INSERT INTO c VALUES (1);
INSERT INTO c VALUES (2);
INSERT INTO c VALUES (3);
INSERT INTO c VALUES (4);
INSERT INTO c VALUES (5);
INSERT INTO c VALUES (6);

INSERT INTO d VALUES (1, 1, 1);
INSERT INTO d VALUES (2, 2, 2);
INSERT INTO d VALUES (3, 3, 3);
INSERT INTO d VALUES (4, 4, 4);
INSERT INTO d VALUES (5, 4, 5);


SELECT a.*,c.* FROM a
NATURAL LEFT JOIN b 
NATURAL LEFT JOIN d 
NATURAL LEFT JOIN c 
WHERE a.dd = 123 order by 1,2,3;

DELETE a FROM a
NATURAL LEFT JOIN b 
NATURAL LEFT JOIN d 
NATURAL LEFT JOIN c 
WHERE a.dd = 123;

SELECT a.*,c.* FROM a
NATURAL LEFT JOIN b 
NATURAL LEFT JOIN d 
NATURAL LEFT JOIN c 
WHERE a.dd = 123 order by 1,2,3;


-----
DELETE FROM A;
DELETE FROM B;
DELETE FROM C;
DELETE FROM D;

INSERT INTO a VALUES (1, 123);
INSERT INTO a VALUES (2, 456);
INSERT INTO a VALUES (3, 123);

INSERT INTO b VALUES (1, 1);
INSERT INTO b VALUES (2, 2);
INSERT INTO b VALUES (3, 3);
INSERT INTO b VALUES (4, 3);

INSERT INTO c VALUES (1);
INSERT INTO c VALUES (2);
INSERT INTO c VALUES (3);
INSERT INTO c VALUES (4);
INSERT INTO c VALUES (5);
INSERT INTO c VALUES (6);

INSERT INTO d VALUES (1, 1, 1);
INSERT INTO d VALUES (2, 2, 2);
INSERT INTO d VALUES (3, 3, 3);
INSERT INTO d VALUES (4, 4, 4);
INSERT INTO d VALUES (5, 4, 5);


SELECT a.*,c.* FROM a
NATURAL RIGHT JOIN b 
NATURAL RIGHT JOIN d 
NATURAL RIGHT JOIN c 
WHERE a.dd = 123 order by 1,2,3;

DELETE a FROM a
NATURAL RIGHT JOIN b 
NATURAL RIGHT JOIN d 
NATURAL RIGHT JOIN c 
WHERE a.dd = 123;

SELECT a.*,c.* FROM a
NATURAL RIGHT JOIN b 
NATURAL RIGHT JOIN d 
NATURAL RIGHT JOIN c 
WHERE a.dd = 123 order by 1,2,3;

-----
DELETE FROM A;
DELETE FROM B;
DELETE FROM C;
DELETE FROM D;

INSERT INTO a VALUES (1, 123);
INSERT INTO a VALUES (2, 456);
INSERT INTO a VALUES (3, 123);

INSERT INTO b VALUES (1, 1);
INSERT INTO b VALUES (2, 2);
INSERT INTO b VALUES (3, 3);
INSERT INTO b VALUES (4, 3);

INSERT INTO c VALUES (1);
INSERT INTO c VALUES (2);
INSERT INTO c VALUES (3);
INSERT INTO c VALUES (4);
INSERT INTO c VALUES (5);
INSERT INTO c VALUES (6);

INSERT INTO d VALUES (1, 1, 1);
INSERT INTO d VALUES (2, 2, 2);
INSERT INTO d VALUES (3, 3, 3);
INSERT INTO d VALUES (4, 4, 4);
INSERT INTO d VALUES (5, 4, 5);


SELECT a.*,c.* FROM a
NATURAL RIGHT JOIN b 
NATURAL LEFT JOIN d 
NATURAL RIGHT JOIN c 
WHERE a.dd = 123 order by 1,2,3;

DELETE a FROM a
NATURAL RIGHT JOIN b 
NATURAL LEFT JOIN d 
NATURAL RIGHT JOIN c 
WHERE a.dd = 123;

SELECT a.*,c.* FROM a
NATURAL RIGHT JOIN b 
NATURAL LEFT JOIN d 
NATURAL RIGHT JOIN c 
WHERE a.dd = 123 order by 1,2,3;


drop table a;
drop table b;
drop table c;
drop table d;
