drop table if exists scores,foo;
CREATE TABLE scores(id INT PRIMARY KEY , math INT, english INT, cs CHAR);
INSERT INTO scores VALUES(1, 30, 70, 'A');
INSERT INTO scores VALUES(2, 40, 70, 'A');
INSERT INTO scores VALUES(3, 60, 80, 'A');
create table foo as
with cte as
(
SELECT PERCENTILE_CONT(0.5)
WITHIN GROUP(ORDER BY math) AS pcont
FROM scores
) select * from cte;
select * from foo;



drop table if exists tbl,foo1,foo2;
CREATE TABLE tbl (col1 int, col2 double);
INSERT INTO tbl VALUES(1,2), (1,1.5), (1,1.7), (1,1.8), (2,3), (2,4), (3,5);

create table foo1 as
with cte as
(
 SELECT col1, MEDIAN(col2) as mdn
 FROM tbl GROUP BY col1
) select * from cte;

create table foo2 as
with cte as
(
SELECT col1, MEDIAN(col2) OVER (PARTITION BY col1) as mdn
FROM tbl
) select * from cte;

describe foo1;
describe foo2;

drop table if exists scores,foo;
