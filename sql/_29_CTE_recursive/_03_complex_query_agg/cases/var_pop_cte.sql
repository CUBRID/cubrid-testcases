drop if exists student;
CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);

with recursive cte as (select * from student),
cte2 as (SELECT VAR_POP(score) FROM student)
SELECT VAR_SAMP(score) FROM cte,cte2  limit 1;

with recursive cte as (select * from student) SELECT subjects_id, name, score, VAR_SAMP(score) OVER(PARTITION BY subjects_id) v_samp
FROM cte
ORDER BY subjects_id, name;

with recursive cte as (
select  1 a,'1' b,1.0 c,1 d,1 e
union all
SELECT subjects_id, name, score, VAR_SAMP(score) OVER(PARTITION BY subjects_id) v_samp,e+1
FROM cte ,student 
where e <5)
select * from cte
ORDER BY a, b, c, d, e;


drop if exists student;
CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);

with recursive cte as (select * from student) SELECT VAR_POP(score) FROM cte;

with recursive cte as (
select 1 m ,1 n
union all
SELECT VAR_POP(score),n+1 FROM student,cte where n<10
)select * from cte order by 1;


drop if exists student;
CREATE TABLE student (name VARCHAR(32), subjects_id INT, score DOUBLE);
INSERT INTO student VALUES
('Jane',1, 78), ('Jane',2, 50), ('Jane',3, 60),
('Bruce', 1, 63), ('Bruce', 2, 50), ('Bruce', 3, 80),
('Lee', 1, 85), ('Lee', 2, 88), ('Lee', 3, 93),
('Wane', 1, 32), ('Wane', 2, 42), ('Wane', 3, 99),
('Sara', 1, 17), ('Sara', 2, 55), ('Sara', 3, 43);

with recursive cte as (select * from student)  SELECT STDDEV_SAMP (cte.score) FROM cte,(
SELECT subjects_id, name, score,
STDDEV_SAMP(score) OVER(PARTITION BY subjects_id) std_samp
FROM student ORDER BY subjects_id, name) y limit 1;


drop if exists student;
CREATE TABLE student (name VARCHAR(32), subjects_id INT, score int);
INSERT INTO student VALUES('Jane',1, 78);

with cte(m,n) as (
select 1 ,1 from db_root
union all
SELECT score,n+1 FROM student,cte where n<10
)select * from cte order by 1,2;

with cte(m,n) as (
select 1 ,1
union all
SELECT score,n+1 FROM student,cte where n<10
)select * from cte order by 1, 2;

with cte(m,n) as (
select 1 ,1
union all
SELECT VAR_POP(score),n+1 FROM student,cte group by score having n<10
)select * from cte order by 1, 2;

drop if exists student;

