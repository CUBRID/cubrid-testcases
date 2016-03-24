-- [er]create table with timestamp data type and insert nchar data


CREATE CLASS t1(
   col1       timestamp 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;