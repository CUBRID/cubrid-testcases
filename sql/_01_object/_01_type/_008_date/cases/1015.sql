-- [er]create table with DATE data type and insert bit data


CREATE CLASS t1(
   col1       DATE
);

INSERT INTO t1 VALUES (B'0001');

drop t1;