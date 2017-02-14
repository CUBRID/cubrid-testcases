--+ holdcas on;
drop table if exists t1;

CREATE TABLE t1(a INT, b INT, c INT);

INSERT INTO t1 VALUES(1,1,1);

INSERT INTO t1 VALUES(2,NULL,2);

INSERT INTO t1 VALUES(2,2,2);

--
WITH cte_Cr2XasKQx AS
(
SELECT a, b
FROM t1
GROUP BY a, b with rollup order by 1,2
)
select * from cte_Cr2XasKQx;

WITH cte_9qd9GL6ta AS
(
SELECT a, b
FROM t1
GROUP BY a, b with rollup order by a,b
)
select * from cte_9qd9GL6ta;

WITH cte_iTk5eW8Tu AS
(
SELECT a, ifnull(b,2) AS b
FROM t1
GROUP BY a, b with rollup order by 1,2
)
select * from cte_iTk5eW8Tu;

WITH cte_wVCLVn9jg AS
(
SELECT a, ifnull(b,2) AS b
FROM t1
GROUP BY a, b with rollup order by a,b
)
select * from cte_wVCLVn9jg;

WITH cte_aPw0lAKri AS
(
SELECT a, ifnull(b,2) AS b
FROM t1 where b=2
GROUP BY a, b with rollup order by a,b
)
select * from cte_aPw0lAKri;

WITH cte_w7RHDESnC AS
(
SELECT a, ifnull(b,2) AS b
FROM t1 where b is null
GROUP BY a, b order by a,b
)
select * from cte_w7RHDESnC;

--

WITH cte_DfH8ADMAD AS
(
SELECT a, ifnull(b,2) AS bxx
FROM t1
GROUP BY a, bxx with rollup order by 1,2
)
select * from cte_DfH8ADMAD;

WITH cte_apGpP9PKg AS
(
SELECT a, ifnull(b,2) AS bxx
FROM t1
GROUP BY a, bxx with rollup order by a,bxx
)
select * from cte_apGpP9PKg;

WITH cte_urg3hPa8J AS
(
SELECT a, ifnull(b,2) AS bxx
FROM t1 where bxx=2
GROUP BY a, bxx with rollup order by a,bxx
)
select * from cte_urg3hPa8J;

WITH cte_SVfQR2ylM AS
(
SELECT a, ifnull(b,2) AS bxx
FROM t1 where b=2
GROUP BY a, bxx with rollup order by a,bxx
)
select * from cte_SVfQR2ylM;

-- CBRD-20821 issue section
drop table if exists t1;

create table t1(a int, b int, c int);

insert into t1 values(1,1,1);

insert into t1 values(2,null,2);

insert into t1 values(2,null,2);

insert into t1 values(2,3,2);

insert into t1 values(2,2,2);

WITH cte_HIBnTj4yv AS
(
select a, b as bxx from t1 group by bxx having bxx is not null
)
select * from cte_HIBnTj4yv order by 1;

drop table t1;

