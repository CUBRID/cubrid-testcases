-- [er]create table with int data type and insert nchar data


CREATE CLASS t1(
   col1       int 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;