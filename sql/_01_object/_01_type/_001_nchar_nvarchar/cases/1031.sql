-- create table with nchar data type and insert nchar data


CREATE CLASS t1(
   col1       nchar  (20)
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;