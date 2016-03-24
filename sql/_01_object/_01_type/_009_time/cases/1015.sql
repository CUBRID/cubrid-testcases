-- [er]create table with TIME data type and insert bit data


CREATE CLASS t1(
   col1       TIME
);

INSERT INTO t1 VALUES (B'0001');

drop t1;