-- [er]create table with monetary data type and insert nchar data


CREATE CLASS t1(
   col1       monetary 
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;