CREATE TABLE aoo (a int primary key, b int);

INSERT INTO aoo VALUES (1, 1), (2, 2), (3, 3);

--error
UPDATE aoo SET a = a + 1, b = b + 1;

UPDATE aoo SET a = a + 1, b = b + 1 ORDER BY a DESC;

SELECT * FROM aoo ORDER BY 1;

DROP TABLE aoo;


CREATE TABLE aoo (a int UNIQUE, b int);

INSERT INTO aoo VALUES (1, 1), (2, 2), (3, 3);

--error
UPDATE aoo SET a = a + 1, b = b + 1 ORDER BY a ASC;

DROP TABLE aoo;


CREATE TABLE aoo (a int PRIMARY KEY, b int);
INSERT INTO aoo VALUES (1, 1), (2, 2), (3, 3);
--error
UPDATE aoo SET a = a + 1, b = b + 1 ORDER BY a ASC;
SELECT * FROM aoo ORDER BY 1;
DROP TABLE aoo;
