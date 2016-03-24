-- [er]create table with SEQUENCE data type and insert bit data


CREATE CLASS t1(
   col1       SEQUENCE
);

INSERT INTO t1 VALUES (B'0001');

drop t1;