-- [er]create table with SEQUENCE data type and insert nchar data


CREATE CLASS t1(
   col1       SEQUENCE 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;