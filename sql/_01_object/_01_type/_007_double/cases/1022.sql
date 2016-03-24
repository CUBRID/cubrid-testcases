-- [er]create table with DOUBLE data type and insert nchar data


CREATE CLASS t1(
   col1       DOUBLE 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;