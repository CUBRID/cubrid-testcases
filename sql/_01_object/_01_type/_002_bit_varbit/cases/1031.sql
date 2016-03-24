-- [er]create table with BIT VARYING data type and insert nchar data


CREATE CLASS t1(
   col1       BIT VARYING  (20)
);

INSERT INTO t1 VALUES (N'aaa');

drop t1;