drop table if exists t1;

CREATE TABLE t1(a int, b enum('Y', 'N'), c int);
insert into t1 values (1,1,1);

--test: in fact, the result of sum(b) is "1.000000000000000e+00" value.
select sum(a), sum(b), sum(c) from t1;
    
drop table if exists t1;
