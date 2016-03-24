-- [er]create table with  NUMERIC data type and insert bit data


CREATE CLASS t1(
   col1       NUMERIC
);

INSERT INTO t1 VALUES (B'0001');

drop t1;