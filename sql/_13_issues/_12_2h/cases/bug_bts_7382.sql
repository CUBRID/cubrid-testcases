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


select dt, case when to_char(dt, 'YYYY-MM-DD')  is null  and dept is not null  and username is not null  then  dept ||'('|| username || ')'||' oopp'  
                  when to_char(dt, 'YYYY-MM-DD')  is null and dept is not null  and username is null   then  dept ||' oopp' 
                  when to_char(dt, 'YYYY-MM-DD')  is null and dept is null  and username is null   then 'rr ss' 
                  ELSE  to_char(dt, 'YYYY-MM-DD') END AS [ttuu],  
         case when to_char(dt, 'YYYY-MM-DD')  is null  then ''
                  ELSE dept END AS [vv], 
         case when to_char(dt, 'YYYY-MM-DD')  is null  then ''
                  ELSE username END AS [ww], 
         to_char( sum_amt, '9,999,999') AS [xxyy]
from (    
      select  dt, dept, username, sum(amt) AS sum_amt
      from t1 AS B 
      group by dept, username, dt with rollup
     ) AS X(dt, dept, username, sum_amt)
where dt is not null;

drop table if exists t1;
