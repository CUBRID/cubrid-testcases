CREATE TABLE T (a int, b int, c int);
CREATE INDEX idx_ab ON T(a, b);

INSERT INTO T VALUES (0,0,0);
INSERT INTO T VALUES (0,0,100);
INSERT INTO T VALUES (0,10,0);
INSERT INTO T VALUES (0,10,100);
INSERT INTO T VALUES (1,0,0);
INSERT INTO T VALUES (1,0,100);
INSERT INTO T VALUES (1,10,0);
INSERT INTO T VALUES (1,10,100);

SELECT a, b FROM T WHERE a >= 0 GROUP BY a, b order by 1,2;



select count(*) from (SELECT a, b FROM T WHERE a >= 0 GROUP BY a, b HAVING groupby_num() < 2) t;
select count(*) from (SELECT a, b FROM T WHERE a >= 0 GROUP BY a, b HAVING groupby_num() < 3) t;
select count(*) from (SELECT a, b FROM T WHERE a >= 0 GROUP BY a, b HAVING groupby_num() < 4) t;
select count(*) from (SELECT a, b FROM T WHERE a >= 0 GROUP BY a, b HAVING groupby_num() < 5) t;
select count(*) from (SELECT a, b FROM T WHERE a >= 0 GROUP BY a, b HAVING groupby_num() < 6) t;


drop table T;

