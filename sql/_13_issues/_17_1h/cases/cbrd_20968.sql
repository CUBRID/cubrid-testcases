drop if exists student;
CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score, VAR_SAMP(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student   
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

drop if exists student;
CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score, DENSE_RANK() OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

drop if exists student;
CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  FIRST_VALUE(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

drop if exists student;
CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  count(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  lag(score,1) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  LAST_VALUE(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  lead(score,1) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;
CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  max(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  median(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  min(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;


CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  NTH_VALUE(score,2) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  NTILE(5) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  PERCENT_RANK() OVER(PARTITION BY subjects_id order by subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;


CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  RANK() OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  ROW_NUMBER() OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;


CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  STDDEV_POP(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;


CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  STDDEV_SAMP(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  VAR_POP(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;

CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);
with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score,  VAR_SAMP(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student
where e <5)
select * from cte
ORDER BY a, b,c,d,e limit 10;
drop if exists student;


