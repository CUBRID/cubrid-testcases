--03_natural_join_bug_from_web_007.sql
drop table if exists d,c,b,a;
CREATE TABLE a (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id),
	uid BIGINT
);

CREATE TABLE b (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id),
	a_id BIGINT NOT NULL, CONSTRAINT fk_a__id FOREIGN KEY fk_idx_a__id (a_id) REFERENCES a (id) ON DELETE CASCADE
);

---
delete from a;
delete from b;


INSERT INTO a VALUES (1, 123), (2, 456), (3, 123);
INSERT INTO b VALUES (1, 1), (2, 2), (3, 3), (4, 3);

select * from a order by 1,2;
select * from b order by 1,2;

DELETE a,b FROM a join b on a.id = b.a_id WHERE a.uid = 123;

select * from a order by 1,2;
select * from b order by 1,2;

---
delete from a;
delete from b;

INSERT INTO a VALUES (1, 123), (2, 456), (3, 123);
INSERT INTO b VALUES (1, 1), (2, 2), (3, 3), (4, 3);

select * from a order by 1,2;
select * from b order by 1,2;

DELETE a,b FROM a
LEFT JOIN b ON b.a_id = a.id
WHERE a.uid = 123;

select * from a order by 1,2;
select * from b order by 1,2;

---
delete from a;
delete from b;

INSERT INTO a VALUES (1, 123), (2, 456), (3, 123);
INSERT INTO b VALUES (1, 1), (2, 2), (3, 3), (4, 3);

select * from a order by 1,2;
select * from b order by 1,2;

DELETE a,b FROM a
NATURAL LEFT JOIN b
WHERE a.uid = 123;

select * from a order by 1,2;
select * from b order by 1,2;

---
delete from a;
delete from b;

INSERT INTO a VALUES (1, 123), (2, 456), (3, 123);
INSERT INTO b VALUES (1, 1), (2, 2), (3, 3), (4, 3);

select * from a order by 1,2;
select * from b order by 1,2;

DELETE a,b FROM a
NATURAL RIGHT JOIN b
WHERE a.uid = 123;

select * from a order by 1,2;
select * from b order by 1,2;

drop table if exists d,c,b,a;

--need verify
drop table if exists TableA,TableB;
create table TableA ( id int, name varchar(20));
create table TableB ( id int, name varchar(20));
insert into TableA values(1,'Pirate'),(2,'Monkey'),(3,'Ninja'),(4,'Spaghetti');
insert into TableB values(1,'Rutabaga'),(2,'Pirate'),(3,'Darth Vader'),(4,'Ninja');

---------------[Natural][Inner] join -------------------
SELECT * FROM TableA
JOIN TableB
ON TableA.name = TableB.name order by 1,2;

SELECT * FROM TableA
INNER JOIN TableB
ON TableA.name = TableB.name order by 1,2;

SELECT * FROM TableA
NATURAL JOIN TableB order by 1,2;

SELECT * FROM TableA
NATURAL INNER JOIN TableB order by 1,2;

---------------[Natural] Left [Outer] join -------------------

SELECT * FROM TableA
LEFT JOIN TableB
ON TableA.name = TableB.name order by 1,2;

SELECT * FROM TableA
LEFT OUTER JOIN TableB
ON TableA.name = TableB.name order by 1,2;

SELECT * FROM TableA
NATURAL LEFT JOIN TableB order by 1,2;

SELECT * FROM TableA
NATURAL LEFT OUTER JOIN TableB order by 1,2;

---------------[Natural] Right [Outer] join -------------------
SELECT * FROM TableA
RIGHT JOIN TableB
ON TableA.name = TableB.name order by 1,2,3,4;

SELECT * FROM TableA
RIGHT OUTER JOIN TableB
ON TableA.name = TableB.name order by 1,2,3,4;

SELECT * FROM TableA
NATURAL RIGHT JOIN TableB order by 1,2,3,4;

SELECT * FROM TableA
NATURAL RIGHT OUTER JOIN TableB order by 1,2,3,4;

---------------[Natural] Left [Outer] join Is Null -------------------
SELECT * FROM TableA
LEFT JOIN TableB
ON TableA.name = TableB.name
WHERE TableB.id IS null order by 1,2;

SELECT * FROM TableA
NATURAL LEFT JOIN TableB
WHERE TableB.id IS null order by 1,2;

SELECT * FROM TableA
LEFT OUTER JOIN TableB
ON TableA.name = TableB.name
WHERE TableB.id IS null order by 1,2;

SELECT * FROM TableA
NATURAL LEFT OUTER JOIN TableB
WHERE TableB.id IS null order by 1,2;

---------------[Natural] Right [Outer] join Is Null -------------------
SELECT * FROM TableA
RIGHT JOIN TableB
ON TableA.name = TableB.name
WHERE TableB.id IS null order by 1,2;

SELECT * FROM TableA
NATURAL RIGHT JOIN TableB
WHERE TableB.id IS null order by 1,2;

SELECT * FROM TableA
RIGHT OUTER JOIN TableB
ON TableA.name = TableB.name
WHERE TableB.id IS null order by 1,2;

SELECT * FROM TableA
NATURAL RIGHT OUTER JOIN TableB
WHERE TableB.id IS null order by 1,2;

---------------Straight_join -------------------
SELECT * FROM TableA
STARIGHT_JOIN TableB;

SELECT * FROM TableA
STARIGHT_JOIN TableB
ON TableA.name = TableB.name order by 1,2;

SELECT * FROM TableA
INNER JOIN TableB
ON TableA.name = TableB.name order by 1,2;

SELECT * FROM TableA
JOIN TableB
ON TableA.name = TableB.name order by 1,2;

---------------cross join -------------------
SELECT * FROM TableA
cross join TableB order by 1,2,3,4;

drop table if exists TableA,TableB;
