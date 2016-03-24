-- [er]create table with TIME data type and insert nchar data


CREATE CLASS t1(
   col1       TIME 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;