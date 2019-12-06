drop table if exists t1;

create table t1(
  dt date, 
  dept varchar(60), 
  username varchar(60),
  amt numeric(20)
  );  

insert into t1 values('2012-03-01', 'aabb', 'ccdd',  1000 );
insert into t1 values('2012-03-02', 'aabb', 'ccdd',  2000 );
insert into t1 values('2012-03-03', 'aabb', 'ccdd',  3000 );
insert into t1 values('2012-03-04', 'aabb', 'ccdd',  4000 );
insert into t1 values('2012-03-05', 'aabb', 'eeff',  5000 );
insert into t1 values('2012-03-06', 'aabb', 'eeff',  6000 );
insert into t1 values('2012-03-07', 'aabb', 'eeff',  7000 );
insert into t1 values('2012-03-08', 'aabb', 'gghh',  8000 );
insert into t1 values('2012-03-09', 'aabb', 'gghh',  9000 );
insert into t1 values('2012-03-10', 'aabb', 'gghh', 10000 );
insert into t1 values('2012-03-11', 'kkll', 'iijj', 13000 );
insert into t1 values('2012-03-12', 'kkll', 'iijj', 14000 );
insert into t1 values('2012-03-13', 'kkll', 'iijj', 15000 );
insert into t1 values('2012-03-14', 'kkll', 'mmnn', 16000 );
insert into t1 values('2012-03-15', 'kkll', 'mmnn', 17000 );
insert into t1 values('2012-03-16', 'kkll', 'mmnn', 18000 );

SELECT dt,      
    CASE
    WHEN to_char(dt, 'YYYY-MM-DD') is null
        AND dept is NOT null
        AND username is NOT NULL THEN
    dept ||'('|| username || ')'||' oopp'
    WHEN to_char(dt, 'YYYY-MM-DD') is null
        AND dept is NOT null
        AND username is NULL THEN
    dept ||' oopp'
    WHEN to_char(dt, 'YYYY-MM-DD') is null
        AND dept is null
        AND username is NULL THEN
    'rr ss'
    ELSE to_char(dt, 'YYYY-MM-DD')
    END AS [ttuu],
    CASE
    WHEN to_char(dt, 'YYYY-MM-DD') is NULL THEN
    ''
    ELSE dept
    END AS [vv],
    CASE
    WHEN to_char(dt, 'YYYY-MM-DD') is NULL THEN
    ''
    ELSE username
    END AS [ww], to_char( sum_amt, '9,999,999') AS [xxyy]
FROM 
    (SELECT dt,
         dept,
         username,
         sum(amt) AS sum_amt
    FROM t1 AS B
    GROUP BY  dept, username, dt
    WITH rollup ) AS X(dt, dept, username, sum_amt)
WHERE dt is NOT null;

drop table if exists t1;
