--fix between and or error


CREATE TABLE tab0(pk INTEGER PRIMARY KEY, col0 INTEGER, col1 FLOAT, col2 VARCHAR, col3 INTEGER, col4 FLOAT, col5 VARCHAR);

INSERT INTO tab0 VALUES(0,30,20.40,'nztwp',16,40.7,'fapep');
INSERT INTO tab0 VALUES(1,25,54.31,'tzynq',2,2.58,'qpxlz');
INSERT INTO tab0 VALUES(2,64,21.7,'kdbxx',97,51.56,'xngtg');
INSERT INTO tab0 VALUES(4,92,30.98,'jwiwi',61,32.44,'zcrud');


SELECT pk FROM tab0 WHERE ( col0 >= 81 AND col0 <= 23) OR (col0 = 92);

--should be same with the above result
SELECT pk FROM tab0 WHERE col0 BETWEEN 81 AND 23 OR (col0 = 92);


drop table tab0;
