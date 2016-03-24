-- [er]create table with NUMERIC data type and insert nchar data


CREATE CLASS t1(
   col1       NUMERIC 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;