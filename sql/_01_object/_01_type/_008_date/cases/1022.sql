-- [er]create table with DATE data type and insert nchar data


CREATE CLASS t1(
   col1       DATE 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;