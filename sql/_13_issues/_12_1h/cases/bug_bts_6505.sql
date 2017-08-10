CREATE TABLE t1 (col1 decimal (5, 2) , col2 numeric (5, 2) );
INSERT INTO t1 VALUES (999.999, 999.999);
-- You will see 1000.00 is inserted. We suppose it is correct.
select * from t1;
-- Insert the same value with existing value 1000.00 , You will find failed result.
INSERT INTO t1 VALUES (1000.00, 1000.00);
INSERT INTO t1 VALUES (1000.0, 1000.0);
select * from t1;

drop table t1;
CREATE TABLE t1 (col1 decimal (5, 2) , col2 numeric (5, 2) );
INSERT INTO t1 VALUES (999.999, 999.999);
INSERT INTO t1 VALUES (1.999, 10.999);

INSERT INTO t1 VALUES (111.110, 111.110);
select * from t1;
drop table t1;

