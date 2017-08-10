SELECT v.a, row_number() over(PARTITION BY 1 + 0) r
FROM (VALUES (1), (2), (3)) v (a);

SELECT v.a, row_number() over(PARTITION BY NULL) r
FROM (VALUES (1), (2), (3)) v (a);

SELECT row_number() over(PARTITION BY 1 + 0) r FROM db_root;

SELECT row_number() over(PARTITION BY NULL) r FROM db_root;

create table t(i int);

insert into t values(1),(1),(2),(2),(3),(3);

insert into t select * from t;

SELECT i, row_number() over(PARTITION BY i) r FROM t order by i;

SELECT i, row_number() over(PARTITION BY i + 4) r FROM t order by i;

select r from (SELECT i, row_number() over(PARTITION BY NULL) r FROM t ) order by r;

select r from (SELECT i, row_number() over(PARTITION BY 5 - 4) r FROM t ) order by r;
select r from (SELECT i, row_number() over(PARTITION BY 1/0) r FROM t) order by r;
SELECT i, row_number() over(PARTITION BY 1.1) r FROM t order by i;
SELECT i, row_number() over(PARTITION BY 11111111111111111111111111111111111111111111111111) r FROM t order by i;
SELECT i, row_number() over(PARTITION BY 0) r FROM t order by i;
select r from (SELECT i, row_number() over(PARTITION BY -1) r FROM t) order by r;

drop table t;
