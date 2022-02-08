--03_natural_join_bug_from_web_003.sql

drop table if exists d,b,c,a;
CREATE TABLE a (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id),
	uid BIGINT
);

CREATE TABLE b (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id),
	a_id BIGINT NOT NULL, CONSTRAINT fk_a__id FOREIGN KEY fk_idx_a__id (a_id) REFERENCES a (id) ON DELETE CASCADE
) ;

CREATE TABLE c (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id)
) ;

CREATE TABLE d (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id),
	b_id BIGINT NOT NULL, CONSTRAINT fk_b__id FOREIGN KEY fk_idx_b__id (b_id) REFERENCES b (id) ON DELETE CASCADE,
	c_id BIGINT NULL, CONSTRAINT fk_c__id FOREIGN KEY fk_idx_c__id (c_id) REFERENCES c (id) ON DELETE CASCADE
) ;

INSERT INTO a VALUES (1, 123), (2, 456), (3, 123);
INSERT INTO b VALUES (1, 1), (2, 2), (3, 3), (4, 3);
INSERT INTO c VALUES (1), (2), (3), (4), (5), (6);
INSERT INTO d VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 4, 5);


SELECT *, 'a' AS name FROM a order by 1,2,3; 
SELECT *, 'b' AS name FROM b order by 1,2,3; 
SELECT *, 'c' AS name FROM c order by 1,2; 
SELECT *, 'd' AS name FROM d order by 1,2,3;

SELECT a.*, c.* FROM a
LEFT JOIN b ON b.a_id = a.id
LEFT JOIN d ON d.b_id = b.id
LEFT JOIN c ON c.id = d.c_id
WHERE a.uid = 123 order by 1,2,3;

SELECT * FROM a
NATURAL LEFT JOIN b
NATURAL LEFT JOIN d
NATURAL LEFT JOIN c
WHERE a.uid = 123 order by 1,2,3,4,5;

--bug
DELETE a, c FROM a
LEFT JOIN b ON b.a_id = a.id
LEFT JOIN d ON d.b_id = b.id
LEFT JOIN c ON c.id = d.c_id
WHERE a.uid = 123;

SELECT count(*) FROM a
LEFT JOIN b ON b.a_id = a.id
LEFT JOIN d ON d.b_id = b.id
LEFT JOIN c ON c.id = d.c_id
WHERE a.uid = 123;


SELECT *, 'a' AS name FROM a; 
SELECT *, 'b' AS name FROM b; 
SELECT *, 'c' AS name FROM c; 
SELECT *, 'd' AS name FROM d;
drop table if exists d,b,c,a;

--------------------------------
drop table if exists d,b,c,a;
CREATE TABLE a (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id),
	uid BIGINT
);

CREATE TABLE b (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id),
	a_id BIGINT NOT NULL, CONSTRAINT fk_a__id FOREIGN KEY fk_idx_a__id (a_id) REFERENCES a (id) ON DELETE CASCADE
) ;

CREATE TABLE c (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id)
) ;

CREATE TABLE d (
	id BIGINT NOT NULL AUTO_INCREMENT, PRIMARY KEY (id),
	b_id BIGINT NOT NULL, CONSTRAINT fk_b__id FOREIGN KEY fk_idx_b__id (b_id) REFERENCES b (id) ON DELETE CASCADE,
	c_id BIGINT NULL, CONSTRAINT fk_c__id FOREIGN KEY fk_idx_c__id (c_id) REFERENCES c (id) ON DELETE CASCADE
) ;

INSERT INTO a VALUES (1, 123), (2, 456), (3, 123);
INSERT INTO b VALUES (1, 1), (2, 2), (3, 3), (4, 3);
INSERT INTO c VALUES (1), (2), (3), (4), (5), (6);
INSERT INTO d VALUES (1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 4, 5);

DELETE a, c FROM a
NATURAL LEFT JOIN b
NATURAL LEFT JOIN d
NATURAL LEFT JOIN c
WHERE a.uid = 123;

truncate table a cascade;
truncate table b cascade;
truncate table c cascade;
truncate table d;

SELECT *, 'a' AS name FROM a; 
SELECT *, 'b' AS name FROM b; 
SELECT *, 'c' AS name FROM c; 
SELECT *, 'd' AS name FROM d;

drop table if exists d,b,c,a;


DROP TABLE IF EXISTS T1,T2;
CREATE TABLE T1
(
    T1ID    integer NOT NULL,
    SomeID  integer NOT NULL,
        PRIMARY KEY (T1ID)
);

CREATE TABLE T2
(
    T2ID    integer NOT NULL,
    SomeID  integer NOT NULL,
        PRIMARY KEY (T2ID)
);

INSERT T1
    (T1ID,SomeID)
VALUES
    (1,123), (2,123), (3,123),
    (4,123), (5,123), (6,123),
    (7,123), (8,123), (9,123),
    (10,123), (11,123), (12,123),
    (13,123), (14,123);


INSERT T2
    (T2ID,SomeID)
VALUES
    (1,123), (2,123), (3,123),
    (4,123), (5,123), (6,123),
    (7,123), (8,123), (9,123),
    (10,123), (11,123), (12,123),
    (13,123), (14,123);

SELECT
    T2.T2ID
from (select * from t1 order by 1,2) t1
join (select * from t2 order by 1,2) t2
    ON T2.T2ID = T1.T1ID
WHERE
    T1.SomeID = 123 order by 1;

SELECT
    T2.T1ID
from (select * from t1 order by 1,2) t2
join (select * from t2 order by 1,2) t1
    ON T2.T1ID = T1.T2ID
WHERE
    T1.SomeID = 123 order by 1;

SELECT
    T2.T2ID
from (select * from t1 order by 1,2) T1
natural join (select * from t2 order by 1,2) T2
WHERE
    T1.SomeID = 123 order by 1; 


SELECT
    T2.T1ID
from (select * from t1 order by 1,2) T2
natural join (select * from t2 order by 1,2) T1
WHERE
    T1.SomeID = 123 order by 1; 


SELECT
    T2.T2ID
from (select * from t1 order by 1,2) T1
natural left join (select * from t2 order by 1,2) T2
WHERE
    T1.SomeID = 123 order by 1; 


SELECT
    T2.T1ID
from (select * from t1 order by 1,2) T2
natural left join (select * from t2 order by 1,2) T1
WHERE
    T1.SomeID = 123 order by 1; 

SELECT
    T2.T2ID
from (select * from t1 order by 1,2) T1
natural right join (select * from t2 order by 1,2) T2
WHERE
    T1.SomeID = 123 order by 1; 


SELECT
    T2.T1ID
from (select * from t1 order by 1,2) T2
natural right join (select * from t2 order by 1,2) T1
WHERE
    T1.SomeID = 123 order by 1; 

DROP TABLE IF EXISTS T1,T2;


DROP TABLE IF EXISTS MY_TABLE,MY_SECOND_TABLE;

CREATE  TABLE `MY_TABLE` (`id` DOUBLE NOT NULL );

INSERT INTO MY_TABLE VALUES (123.456);
INSERT INTO MY_TABLE VALUES (124.000);

CREATE  TABLE `MY_SECOND_TABLE` (`a_field` INT NOT NULL );

INSERT INTO MY_SECOND_TABLE VALUES (9);

SELECT
mv.id AS `conditional`,
mv.id as `always`,
mv.id  as `only_cast`
FROM MY_TABLE mv
    INNER JOIN MY_SECOND_TABLE mst
        ON 1<>0 order by 1,2,3;


SELECT
mv.id AS `conditional`,
mv.id as `always`,
mv.id  as `only_cast`
FROM MY_TABLE mv
    natural JOIN MY_SECOND_TABLE mst
        order by 1,2,3;


SELECT
mv.id AS `conditional`,
mv.id as `always`,
mv.id  as `only_cast`
FROM MY_TABLE mv
    natural left JOIN MY_SECOND_TABLE mst
        order by 1,2,3;


SELECT
mv.id AS `conditional`,
mv.id as `always`,
mv.id  as `only_cast`
FROM MY_TABLE mv
    natural right JOIN MY_SECOND_TABLE mst
        order by 1,2,3;


DROP TABLE IF EXISTS MY_TABLE,MY_SECOND_TABLE;



drop table if exists b,a,mn;
drop table if exists a,b,mn;
create table A(id int primary key, s varchar(255));
create table B(id int primary key, s varchar(255));
create table mn( aid int, bid int );
insert into A values (1,'A1'),(2,'A2');
insert into B values (1,'B1'),(2,'B2');
insert into mn values (1,1);
select * from B right join mn on bid=B.id right join A on aid=A.id order by 1,2,3,4,5,6;
select * from B right join mn on bid=B.id right join A on aid=A.id where B.id is null order by 1,2,3,4,5,6;

select * from B natural right join mn natural right join A order by 1,2,3,4,5,6;
select * from B natural right join mn natural right join A where B.id is null order by 1,2,3;


drop table if exists b,a,mn;
drop table if exists a,b,mn;
