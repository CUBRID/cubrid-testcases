drop if exists tab0;

CREATE TABLE tab0(pk INTEGER, col0 INTEGER );
INSERT INTO tab0 VALUES(1,1);

SELECT 21 FROM tab0 WHERE not - col0 = - col0; 
SELECT 21 FROM tab0 WHERE not col0 = col0;
SELECT *  FROM tab0 WHERE  - col0 = - col0;
SELECT 21 FROM tab0 WHERE not col0 = - col0;
SELECT 21 FROM tab0 WHERE not - col0 <> - col0;

drop tab0;

CREATE TABLE tab0(pk INTEGER, col0 varchar(10) );
INSERT INTO tab0 VALUES(1,'abc~~');

SELECT 21 FROM tab0 WHERE not col0 = col0; 
SELECT *  FROM tab0 WHERE  col0 = col0;
SELECT 21 FROM tab0 WHERE not col0 <> col0;

drop tab0;

CREATE TABLE tab0(pk INTEGER, col0 datetime );
INSERT INTO tab0 VALUES(1,'2012-05-31 13:25:59');

SELECT 21 FROM tab0 WHERE not col0 = col0;
SELECT *  FROM tab0 WHERE  col0 = col0;
SELECT 21 FROM tab0 WHERE not col0 <> col0;

drop tab0;

CREATE TABLE tab0(pk INTEGER, col0 smallint);
INSERT INTO tab0 VALUES(1,100);

SELECT 21 FROM tab0 WHERE not - col0 = - col0; 
SELECT 21 FROM tab0 WHERE not col0 = col0;
SELECT *  FROM tab0 WHERE  - col0 = - col0;
SELECT 21 FROM tab0 WHERE not col0 = - col0;
SELECT 21 FROM tab0 WHERE not - col0 <> - col0;

drop tab0;

CREATE TABLE tab0(pk INTEGER, col0 double);
INSERT INTO tab0 VALUES(1,100);

SELECT 21 FROM tab0 WHERE not - col0 = - col0; 
SELECT 21 FROM tab0 WHERE not col0 = col0;
SELECT *  FROM tab0 WHERE  - col0 = - col0;
SELECT 21 FROM tab0 WHERE not col0 = - col0;
SELECT 21 FROM tab0 WHERE not - col0 <> - col0;

drop tab0;

CREATE TABLE tab0(pk INTEGER, col0 monetary);
INSERT INTO tab0 VALUES(1,100);

SELECT 21 FROM tab0 WHERE not - col0 = - col0; 
SELECT 21 FROM tab0 WHERE not col0 = col0;
SELECT *  FROM tab0 WHERE  - col0 = - col0;
SELECT 21 FROM tab0 WHERE not col0 = - col0;
SELECT 21 FROM tab0 WHERE not - col0 <> - col0;

drop tab0;